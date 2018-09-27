#!/bin/bash
# Brett Waugh
# 21 September 2018
# Script should setup a containzerization of Splunk 7.1.2 using Docker. 

echo Please enter what you want the admin password to be. 

read new_password

echo Please wait... This could take a few minutes... 

docker pull splunk/splunk

echo Got the pull.

docker run -p 8000:8000 -d -e SPLUNK_START_ARGS="--accept-license --seed-passwd $new_password" splunk/splunk

echo Setup Complete. Please visit localhost:8000 for Splunk webpage.
