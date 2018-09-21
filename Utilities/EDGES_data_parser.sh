#!/bin/bash
# Script to format the EDGES data into a CSV. The deliminator is a space, not a comma so please take that into account. 
# Brett Waugh 31 August 2018

echo This script will convert your EDGES data from JSON to CSV.

echo Please be in the same directory as the file you need to process.

echo What is the name of the file you are trying to convert? Please include the file extension.

read original_file

echo Please enter the path to where you want to save the file.

read file_location

echo Finally, enter the new file name. Please include the file extension.  

read new_file

touch $file_location/$new_file

echo File name:     $original_file
echo File location: $file_location
echo File new name: $new_file

echo Working on it...This may take several minute...

echo "ID" "Frequency" "Power" "Geo_Latitude" "Geo_Longitude" "Location_Sucess" "Location_Latitude" "Location_Longitude" "Location_Accuracy" "Altitude" "Altitude_Accuracy" "Heading" "Speed" "Timestamp" "Source_Created" > $file_location/$new_file

while read p; do echo $(echo "$p" | jq '(._id, ._source.frequency, ._source.power, ._source.geo.lat, ._source.geo.lon, ._source.location.success, ._source.location.latitude, ._source.location.longitude, ._source.location.locationAccuracy, ._source.location.altitude, ._source.location.altitudeAccuracy, ._source.location.heading, ._source.location.speed, ._source.location.timestamp, ._source.created)' ); done < $original_file >> $file_location/$new_file

echo Finished.
