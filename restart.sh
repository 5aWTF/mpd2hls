#!/bin/bash

# Stop the processes using stop.sh (if running)
./stop.sh

# Start the main script (mpd2hls_v2.sh) with the same arguments
if [ $# -eq 4 ]; then
    ./mpd2hls_v2.sh -folder "$1" -file "$2" -url "$3" -key "$4"  &
else
    echo "Usage: $0 -folder StreamFolder_Name -file NameOfFile_WITHOUT_EXTENSIONS -url 'Stream_URL' -key 'your_key_and_kid_here' &"
    echo "-------"
    echo "-custom-proxy | For custom Proxy Server"
    echo "-use-shaka | For Shaka Packager, Shaka Packager must be installed"
    echo "-log-no-print | Log output of ffmpeg and N_m3u8D-RE and hide print while running."
    echo "-no-logs-or-print | Does not log ffmpeg and N_m3u8D-RE and hide as well prints while running."
    echo "-------"
    exit 1
fi
