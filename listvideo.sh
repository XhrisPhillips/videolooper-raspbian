#!/bin/bash
# Bash script by Tim Schwartz, http://www.timschwartz.org/raspberry-pi-video-looper/ 2013
# Comments, clean up, improvements by Derek DeMoss, for Dark Horse Comics, Inc. 2015
# Added USB support, full path, support files with spaces in names, support more file formats - Tim Schwartz, 2016

declare -A VIDS # make variable VIDS an Array

LOCAL_FILES=/videos/ # A variable of this folder
USB_FILES=/mnt/usbdisk/ # Variable for usb mount point
CURRENT=0 # Number of videos in the folder
FILE_FORMATS='.mov|.mp4|.mpg'

getvids () # Since I want this to run in a loop, it should be a function
{
unset VIDS # Empty the VIDS array
CURRENT=0 # Reinitializes the video count
IFS=$'\n' # Dont split up by spaces, only new lines when setting up the for loop
for f in `ls $LOCAL_FILES | grep -E $FILE_FORMATS` # Step through the local files
do
	VIDS[$CURRENT]=$LOCAL_FILES$f # add the filename found above to the VIDS array
	let CURRENT+=1 # increment the video count
done
if [ -d "$USB_FILES" ]; then
  for f in `ls $USB_FILES | grep -E $FILE_FORMATS` # Step through the usb files
	do
		VIDS[$CURRENT]=$USB_FILES$f # add the filename found above to the VIDS array
		let CURRENT+=1 # increment the video count
	done
fi
}

getvids # Get a list of the current videos in the folder
if [ $CURRENT -gt 0 ] #only list videos if there are more than one video
then
    printf '%s\n' "${VIDS[@]}"
fi
