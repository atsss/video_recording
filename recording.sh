#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <duration>"
    exit 1
fi

# Duration argument
duration=$1

# Run libcamera-vid to record video
libcamera-vid -t $duration -o video.h264 &
PID1=$!  # Get PID of the first background process

# Run record to record audio
arecord -d $duration audio.wav &
PID2=$!  # Get PID of the second background process

# Wait for both processes to finish
wait $PID1 $PID2

# Combine video and audio using ffmpeg
ffmpeg -i video.h264 -i audio.wav -c:v copy -c:a aac output.mp4

# Clean up temporary files
rm video.h264 audio.wav
