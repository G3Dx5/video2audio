#!/bin/bash

clear

echo '                                                                          '
echo '       _     _           ____                 _ _                         '
echo ' __   _(_) __| | ___  ___|___ \ __ _ _   _  __| (_) ___                   '
echo ' \ \ / / |/ _` |/ _ \/ _ \ __) / _` | | | |/ _` | |/ _ \                  '
echo '  \ V /| | (_| |  __/ (_) / __/ (_| | |_| | (_| | | (_) | _ _ _           '
echo '   \_/ |_|\__,_|\___|\___/_____\__,_|\__,_|\__,_|_|\___(_|_|_|_)          '
echo '                                                                          '
echo 'Extract audio from video files using wrapper for the avconv tool.         '
echo 'Provide a video file and extract the audio to an audio file of your choice.' 
echo '(Will prompt to overwrite if the output file already exists)              '
echo '                                                                  '
echo -n "Enter your video file (include extension): "
read videoFile

# check for no response 
if [ -z $videoFile ]; then 
	echo "You did not enter a video file... exiting"
	exit

fi

echo -n "Provide your audio output name (with extension): "
read audioFilename

# check for no response
if [ -z $audioFilename ]; then
        echo "You did not enter an audio file... exiting"
        exit

fi

VFILESIZE=$(stat -f%z "$videoFile")

if [ -f "$audioFilename" ]; then
    echo "Whoa! $audioFilename already exists...."
    echo "y = overwrite (delete) and continue, n = don't overwrite and exit"
    read -s fileDelete 
    if [[ $fileDelete == 'y' ]]; then
        rm $audioFilename
        echo "Extracting audio.... video file is $VFILESIZE bytes so be patient!"
    else [[ $fileDelete == 'n' ]];
        echo "Exiting.... try again with a different output file name"
        exit
    fi
fi

avconv -i $videoFile -vn -f mp3 $audioFilename > /dev/null 2>&1

echo '                                                          '
echo "Successfully extracted audio from $videoFile              "
AFILESIZE=$(stat -f%z "$audioFilename") 
echo "Output: $audioFilename ($AFILESIZE bytes)"
echo '                                                          '

