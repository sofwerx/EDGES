#!/bin/bash
adb ls /data/local/nhsystem/kali-armhf/sofwerx/EDGES/hackrf/ | grep json | awk '{print $4}' | while read file ; do adb pull /data/local/nhsystem/kali-armhf/sofwerx/EDGES/hackrf/$file ; done
