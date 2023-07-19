#!/bin/bash

# Check if the instance identifier is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 instance_identifier"
    echo "Please provide the instance identifier to stop the corresponding processes."
    exit 1
fi

INSTANCE="$1"

# Stop N_m3u8DL-RE and ffmpeg processes using the saved process IDs for the provided instance
if [ -f "pid_n_m3u8dl_re_$INSTANCE.txt" ]; then
    PID_N_m3u8DL_RE=$(cat "pid_n_m3u8dl_re_$INSTANCE.txt")
    pkill -P $PID_N_m3u8DL_RE
    rm -f "pid_n_m3u8dl_re_$INSTANCE.txt"
fi

if [ -f "pid_ffmpeg_$INSTANCE.txt" ]; then
    PID_ffmpeg=$(cat "pid_ffmpeg_$INSTANCE.txt")
    pkill -P $PID_ffmpeg
    rm -f "pid_ffmpeg_$INSTANCE.txt"
fi

echo "Processes stopped successfully for Instance: $INSTANCE."
