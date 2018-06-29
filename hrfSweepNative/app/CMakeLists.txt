# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.4.1)


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

#add_subdirectory(src/main/cpp/libusb/)

set(LIBUSB_ROOT_REL src/main/cpp/libusb/)
include_directories(${LIBUSB_ROOT_REL}/android)
include_directories(${LIBUSB_ROOT_REL}/libusb)

link_directories(${LIBUSB_ROOT_REL}/android/libs/armeabi-v7a)

add_library( # Sets the name of the library.
                        usb-lib

                        # Sets the library as a shared library.
                        SHARED

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

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in this
# build script, prebuilt third-party libraries, or system libraries.

target_link_libraries( # Specifies the target library.
                       native-lib

                       # Links the target library to the library
                       # included in the NDK.
                       ${android-lib}
                     )
target_link_libraries(usb-lib ${log-lib})
target_link_libraries(native-lib usb-lib)
