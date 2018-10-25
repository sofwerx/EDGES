#!/bin/bash
# Brett Waugh
# 21 September 2018
# Script should setup a containzerization of Splunk 7.1.2 using Docker. 
# For most up to date instructions, please see https://hub.docker.com/r/splunk/splunk/ 

echo Please enter what you want the admin password to be. 

read new_password

echo Please wait... This could take a few minutes... 

docker pull splunk/splunk

echo Got the pull.

docker run -d -p 8000:8000 -e 'SPLUNK_START_ARGS=--accept-license' -e 'SPLUNK_PASSWORD=$new_password' splunk/splunk

echo Setup Complete. Please visit localhost:8000 for Splunk webpage.
