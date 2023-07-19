#!/bin/bash

URL=""
KEY=""
TEMP_DIR="tmp_$RANDOM"

# Function to clean up and remove temporary folders/files
cleanup() {
    echo "Cleaning up..."
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

    rm -rf "$FOLDER" "$TEMP_DIR"
    exit 1
}

# Trap the SIGINT signal (Ctrl+C) to clean up on script termination
trap cleanup SIGINT

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -folder)
        FOLDER="$2"
        shift
        ;;
        -file)
        FILE="$2"
        shift
        ;;
        -url)
        URL="$2"
        shift
        ;;
        -key)
        KEY="$2"
        shift
        ;;
        *)
        # Ignore unknown options
        ;;
    esac
    shift
done

# Check if folder, file, URL, and key are provided
if [ -z "$FOLDER" ] || [ -z "$FILE" ] || [ -z "$URL" ] || [ -z "$KEY" ]; then
    echo "Usage: $0 -folder nameOfTheFolder -file nameOfFile -url 'your_url_here' -key 'your_key_here'"
    exit 1
fi

# Create a unique identifier for this instance
INSTANCE=$(date +%s%N)

# Create the folder and temporary directory
mkdir -p "$FOLDER" "$TEMP_DIR"

# Replace "url" and "keyID:key" with the provided arguments
COMMAND_1="N_m3u8DL-RE --save-dir $FOLDER --del-after-done true --save-name $FILE --tmp-dir $TEMP_DIR $URL --live-real-time-merge true --thread-count 1 --live-wait-time 2 --live-keep-segments false --mp4-real-time-decryption true --live-pipe-mux true -sv best -sa all --key $KEY --use-system-proxy true --custom-proxy xxx.xxx.xxx.xxx:xx -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'"
COMMAND_2="ffmpeg -re -i \"$FOLDER/$FILE.ts\" -c copy -f hls -sc_threshold 0 -pix_fmt yuv420p -attempt_recovery 1 -recovery_wait_time 1 -hls_flags delete_segments -hls_time 2 -hls_list_size 20 \"/var/www/html/$FILE.m3u8\""

# Execute the commands and save the process IDs to files
eval "$COMMAND_1 &"
PID_N_m3u8DL_RE=$!
echo "$PID_N_m3u8DL_RE" > "pid_n_m3u8dl_re_$INSTANCE.txt"

eval "$COMMAND_2 &"
PID_ffmpeg=$!
echo "$PID_ffmpeg" > "pid_ffmpeg_$INSTANCE.txt"

echo "Download and conversion started in the background (Instance: $INSTANCE). Use stop.sh to stop this instance."

# Wait for both processes to complete
wait $PID_N_m3u8DL_RE
wait $PID_ffmpeg

# Clean up the temporary folders/files and process ID files
cleanup
