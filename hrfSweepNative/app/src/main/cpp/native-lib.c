//
// Created by Tracey Birch on 6/28/18.
//

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <jni.h>

#include <android/sensor.h>
#include <libusb.h>
#include <libusbi.h>

JNIEXPORT jstring JNICALL Java_org_sofwerx_hrfsweepnative_HelloFromNative_stringFromJNI(JNIEnv *env, jobject this) {
                return(*env)->NewStringUTF(env, "Hello from JNI (C library)");
}


JNIEXPORT jstring JNICALL Java_org_sofwerx_hrfsweepnative_SensorInterface_listSensors(JNIEnv *env, jobject this, jint fd) {
    ASensorManager *sensman = ASensorManager_getInstance();
    ASensorList senslist;

    const struct libusb_version *usbV = libusb_get_version();
    libusb_context *usbCtx;
    libusb_device ***usbDevs;
    libusb_device_handle **hrfDevHandle;
    libusb_device hrfDev;

    int n;
    char retstr[5000] = "";

    sprintf(retstr,"libusb version %d.%d.%d",usbV->major, usbV->minor, usbV->micro);

    int rc = libusb_init(&usbCtx);
    if(rc < 0) {
        sprintf(retstr, "%s\nFAILED to initialize libusb: %s", retstr, libusb_error_name(rc));
    } else {
        sprintf(retstr, "%s\nlibusb initialized", retstr);

//        ssize_t nDevs = libusb_get_device_list(usbCtx, usbDevs);
//        if (nDevs < 0) {
//            sprintf(retstr, "%s\nFound %d usb devices", retstr, rc);
//        } else {
//
//            sprintf(retstr, "%s\nFAILED to enumerate usb devices: %s", retstr,
//                    libusb_error_name(rc));
//        }

        libusb_wrap_fd(usbCtx, fd, hrfDevHandle);
        libusb_get_device(*hrfDevHandle);
    }

    n = ASensorManager_getSensorList(sensman, &senslist);
    sprintf(retstr, "%s\nSensors:", retstr);
    for (int i = 0; i < n; ++i) {
        const ASensor *s = senslist[i];
        sprintf(retstr, "%s\n%s", retstr, ASensor_getName(s));
    }

    return (*env)->NewStringUTF(env, retstr);
}
