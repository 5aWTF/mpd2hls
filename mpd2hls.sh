#!/bin/bash

URL=""
KEY=""
TEMP_DIR="tmp_$RANDOM"
SERVER_IP="$(curl ifconfig.co --silent)"

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
    rm -rf "/var/www/html/$FOLDER"
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
        -custom-proxy)
        CUSTOM_PROXY="--custom proxy $2"
        shift
        ;;
        -use-shaka)
        SHAKA="--use-shaka-packager"
        shift
        ;;
        -log-no-prnt)
        LOGS_NM3U8DL="> logs/N_m3u8DL_RE 2>&1 &"
        LOGS_FFMPEG="> logs/ffmpeg 2>&1 &"
        shift
        ;;
        -no-logs-or-print)
        NOLOGS_NM3U8DL="> /dev/null 2>&1 &"
        NOLOGS_FFMPEG="> /dev/null 2>&1 &"
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
    echo "Usage: $0 -folder StreamFolder_Name -file NameOfFile_WITHOUT_EXTENSIONS -url 'Stream_URL' -key 'your_key_and_kid_here' &"
    echo "-------"
    echo "-custom-proxy | For custom Proxy Server"
    echo "-use-shaka | For Shaka Packager, Shaka Packager must be installed"
    echo "-log-no-print | Log output of ffmpeg and N_m3u8D-RE and hide print while running."
    echo "-no-logs-or-print | Does not log ffmpeg and N_m3u8D-RE and hide as well prints while running."
    echo "-------"
    exit 1
fi

# Create log folder
mkdir -p "logs"

#Create stream name subfolder inside document root inside /var/www/html
mkdir -p "/var/www/html/$FOLDER"

# Create a unique identifier for this instance
INSTANCE=$(date +%s%N)

# Create the folder and temporary directory
mkdir -p "$FOLDER" "$TEMP_DIR"

# Replace "url" and "keyID:key" with the provided arguments
COMMAND_1="N_m3u8DL-RE --save-dir $FOLDER --del-after-done true --save-name $FILE --tmp-dir $TEMP_DIR $URL $SHAKA --live-real-time-merge true --thread-count 1 --live-wait-time 2 --live-keep-segments false --mp4-real-time-decryption true --live-pipe-mux true -sv best -sa all --key $KEY --use-system-proxy true $CUSTOM_PROXY -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'"
COMMAND_2="ffmpeg -re -i \"$FOLDER/$FILE.ts\" -c copy -f hls -sc_threshold 0 -pix_fmt yuv420p -attempt_recovery 1 -recovery_wait_time 1 -hls_flags delete_segments -hls_time 2 -hls_list_size 20 \"/var/www/html/$FOLDER/$FILE.m3u8\""

# Execute the commands and save the process IDs to files, we will delay the COMMAND_2 for FFMPEG for 40 sec while N_m3u8DL-RE buffer and creates temp files requried for ffmpeg
eval "$COMMAND_1 $LOGS_NM3U8DL $NOLOGS_NM3U8DL"
eval "sleep 30 && $COMMAND_2 $LOGS_FFMPEG $NOLOGS_FFMPEG"
PID_N_m3u8DL_RE=$!
PID_ffmpeg=$!
echo "$PID_N_m3u8DL_RE" > "pid_n_m3u8dl_re_$INSTANCE.txt"
echo "$PID_ffmpeg" > "pid_ffmpeg_$INSTANCE.txt"
echo ""
echo "Download and conversion started in the background (Instance: $INSTANCE)."
echo "Use stop.sh to stop this instance"
echo "please wait for 40sec for m3u8 file to be generated in the /var/www/html/$FOLDER/$FILE.m3u8"
echo "Your stream should be available at: http://$server_ip/$FOLDER/$FILE.m3u8"
echo "Hit enter to continue using this terminal"

# Wait for both processes to complete
wait $PID_N_m3u8DL_RE
wait $PID_ffmpeg


# Clean up the temporary folders/files and process ID files
cleanup
