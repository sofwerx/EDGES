# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.4.1)
#set(GCC_COVERAGE_LINK_FLAGS -L/swx/local/swx-vmhost/edges/hrfSweepNative/app/libs/arm64-v8a)



# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds them for you.
# Gradle automatically packages shared libraries with your APK.

add_library( # Sets the name of the library.
             native-lib

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             src/main/cpp/native-lib.c
           )


# ${CMAKE_CURRENT_SOURCE_DIR} = /swx/local/swx-vmhost/edges/hrfSweepNative/app
set(LINK_LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/arm64-v8a)
set(INCLUDE_DIR include)
set(LIBUSB_ROOT_REL src/main/cpp/libusb)
set(HACKRF_ROOT_REL src/main/cpp/hackrf)

# for libhackrf
set (PROJECT_SOURCE_DIR   ${HACKRF_ROOT_REL}/host)
set(LIBUSB_LIBRARIES    ${LIBUSB_ROOT_REL}/libusb)
set (LIBUSB_INCLUDE_DIR  ${LIBUSB_ROOT_REL}/libusb)

include_directories(${LIBUSB_ROOT_REL}/libusb)
include_directories(${LIBUSB_ROOT_REL}/android)
include_directories(${LIBUSB_ROOT_REL}/arm64-v8a)

#link_directories(${LIBUSB_ROOT_REL}/android/libs/arm64-v8a)
link_directories(${LINK_LIB_DIR})
include_directories(${INCLUDE_DIR})


add_library( # Sets the name of the library.
                        usb-lib

                        # Sets the library as a shared library.
                        STATIC

                        # Provides a relative path to your source file(s).
                          ${LIBUSB_ROOT_REL}/libusb/core.c
                          ${LIBUSB_ROOT_REL}/libusb/descriptor.c
                          ${LIBUSB_ROOT_REL}/libusb/hotplug.c
                          ${LIBUSB_ROOT_REL}/libusb/io.c
                          ${LIBUSB_ROOT_REL}/libusb/sync.c
                          ${LIBUSB_ROOT_REL}/libusb/strerror.c
                          ${LIBUSB_ROOT_REL}/libusb/os/linux_usbfs.c
                          ${LIBUSB_ROOT_REL}/libusb/os/poll_posix.c
                          ${LIBUSB_ROOT_REL}/libusb/os/threads_posix.c
                          ${LIBUSB_ROOT_REL}/libusb/os/linux_netlink.c
                      )



set (HACKRF_SRC ${HACKRF_ROOT_REL}/host/libhackrf/src)
include_directories(${HACKRF_SRC})

add_library( # Sets the name of the library.
                        hackrf-lib

                        # Sets the library as a shared library.
                        STATIC

                        # Provides a relative path to your source file(s).
                        ${HACKRF_SRC}/hackrf.c
            )

# Searches for a specified prebuilt library and stores the path as a
# variable. Because CMake includes system libraries in the search path by
# default, you only need to specify the name of the public NDK library
# you want to add. CMake verifies that the library exists before
# completing its build.

find_library( # Sets the name of the path variable.
              android-lib
              android
            )
find_library(log-lib log)
#find_library(fftw3-lib fftw3)


# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in this
# build script, prebuilt third-party libraries, or system libraries.
#add_library(  hackrf-lib    STATIC   )
target_link_libraries( # Specifies the target library.
                       native-lib

                       # Links the target library to the library
                       # included in the NDK.
                       ${android-lib}
                     )


target_link_libraries(usb-lib ${log-lib})

set_property(TARGET usb-lib APPEND_STRING PROPERTY LINK_FLAGS " -L${CMAKE_CURRENT_SOURCE_DIR}/libs/armeabi-v7a")
set_property(TARGET usb-lib APPEND_STRING PROPERTY LINK_FLAGS " -mfloat-abi=softfp")
set_property(TARGET usb-lib APPEND_STRING PROPERTY COMPILE_OPTIONS -mfloat-abi=softfp)
set_property(TARGET usb-lib APPEND_STRING PROPERTY COMPILE_OPTIONS -I${CMAKE_CURRENT_SOURCE_DIR}/include)


target_link_libraries(hackrf-lib usb-lib)
#target_link_libraries(hackrf-lib fftw3)
target_link_libraries(hackrf-lib fftw3f)



set_property(TARGET hackrf-lib APPEND_STRING PROPERTY LINK_FLAGS " -L${CMAKE_CURRENT_SOURCE_DIR}/libs/armeabi-v7a")
set_property(TARGET hackrf-lib APPEND_STRING PROPERTY LINK_FLAGS " -mfloat-abi=softfp")
set_property(TARGET hackrf-lib APPEND_STRING PROPERTY COMPILE_OPTIONS -mfloat-abi=softfp)
set_property(TARGET hackrf-lib APPEND_STRING PROPERTY COMPILE_OPTIONS -I${CMAKE_CURRENT_SOURCE_DIR}/include)


target_link_libraries(native-lib usb-lib)
target_link_libraries(native-lib hackrf-lib)
#target_link_libraries(native-lib fftw3)
target_link_libraries(native-lib fftw3f)


set_property(TARGET native-lib APPEND_STRING PROPERTY LINK_FLAGS " -L${CMAKE_CURRENT_SOURCE_DIR}/libs/armeabi-v7a")
set_property(TARGET native-lib APPEND_STRING PROPERTY LINK_FLAGS " -mfloat-abi=softfp")
set_property(TARGET native-lib APPEND_STRING PROPERTY COMPILE_OPTIONS -mfloat-abi=softfp)
set_property(TARGET native-lib APPEND_STRING PROPERTY COMPILE_OPTIONS -I${CMAKE_CURRENT_SOURCE_DIR}/app/include)

