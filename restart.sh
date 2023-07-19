#!/bin/bash

# Stop the processes using stop.sh (if running)
./stop.sh

# Start the main script (mpd2hls.sh) with the same arguments
if [ $# -eq 4 ]; then
    ./mpd2hls.sh -folder "$1" -file "$2" -url "$3" -key "$4" &
else
    echo "Usage: $0 nameOfTheFolder nameOfFile 'your_url_here' 'your_key_here'"
    exit 1
fi
