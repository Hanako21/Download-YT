#!/bin/sh

# --- DEBUGGING START ---
echo "--- Script Debug Info ---"
echo "Argument 1 (\$1): '$1'"
echo "Argument 2 (\$2): '$2'"
echo "--- End Debug Info ---"
# --- DEBUGGING END ---

# Dependencies
if ! command -v yt-dlp >/dev/null 2>&1; then
    pip install yt-dlp --break-system-packages
else
    pip install --upgrade yt-dlp --break-system-packages
fi

mkdir -p ~/Documents/Pipe
OUTPUT_DIR="$HOME/Documents/Pipe"
URL="$1"
MODE="$2"

if [ "$MODE" = "audio" ]; then
    echo "Downloading audio..."
    yt-dlp -f bestaudio -o "$OUTPUT_DIR/%(title)s.opus" "$URL"
    DOWNLOADED_FILE=$(find "$OUTPUT_DIR" -maxdepth 1 -name "*.opus" -print -quit)
    [ -n "$DOWNLOADED_FILE" ] && touch "$DOWNLOADED_FILE"
    open "shortcuts://run-shortcut?name=Download-YT&input=vlc"

elif [ "$MODE" = "video" ]; then

    # 1. Determine the Destination/Return context
    if echo "$URL" | grep -q "ifunny.co"; then
        RETURN_CONTEXT="ifunny"
    elif echo "$URL" | grep -qE "x.com|twitter.com"; then
        RETURN_CONTEXT="x_video"
    else
        RETURN_CONTEXT="vlc"
    fi

    # 2. Path for Photos App (iFunny & X)
    if [ "$RETURN_CONTEXT" = "ifunny" ] || [ "$RETURN_CONTEXT" = "x_video" ]; then
        echo "Photos-targeted download for: $RETURN_CONTEXT"

        YT_DLP_OUTPUT_TEMP_PREFIX="yt-dlp_temp_"
        YT_DLP_OUTPUT_TEMP_PATH="$OUTPUT_DIR/${YT_DLP_OUTPUT_TEMP_PREFIX}%(title)s.mp4"

        yt-dlp "$URL" -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --recode-video mp4 -o "$YT_DLP_OUTPUT_TEMP_PATH"

        DOWNLOADED_FILE_TEMP=$(find "$OUTPUT_DIR" -maxdepth 1 -name "${YT_DLP_OUTPUT_TEMP_PREFIX}*.mp4" -print -quit)

        if [ -n "$DOWNLOADED_FILE_TEMP" ]; then
            FINAL_FILENAME=$(basename "$DOWNLOADED_FILE_TEMP" | sed "s/^${YT_DLP_OUTPUT_TEMP_PREFIX}//")
            FINAL_FILE_PATH="$OUTPUT_DIR/$FINAL_FILENAME"

            ffmpeg -i "$DOWNLOADED_FILE_TEMP" -map_metadata -1 -codec copy -y "$FINAL_FILE_PATH"

            if [ $? -eq 0 ]; then
                rm "$DOWNLOADED_FILE_TEMP"
                touch "$FINAL_FILE_PATH"
            else
                mv "$DOWNLOADED_FILE_TEMP" "$FINAL_FILE_PATH"
                touch "$FINAL_FILE_PATH"
            fi

            # Call shortcut with specific context (ifunny or x_video)
            open "shortcuts://run-shortcut?name=Download-YT&input=$RETURN_CONTEXT"
        else
            echo "Error: File not found."
            exit 1
        fi

    # 3. Path for VLC (YouTube, etc.)
    else
        echo "VLC-targeted download."
        yt-dlp "$URL" -f bestvideo+bestaudio --merge-output-format webm -o "$OUTPUT_DIR/%(title)s.webm"
        DOWNLOADED_FILE=$(find "$OUTPUT_DIR" -maxdepth 1 -name "*.webm" -print -quit)
        [ -n "$DOWNLOADED_FILE" ] && touch "$DOWNLOADED_FILE"
        open "shortcuts://run-shortcut?name=Download-YT&input=vlc"
    fi

elif [ "$MODE" = "spotify" ]; then
    yt-dlp --extract-audio --audio-format mp3 -o "$OUTPUT_DIR/%(title)s.mp3" "$URL"
    DOWNLOADED_FILE=$(find "$OUTPUT_DIR" -maxdepth 1 -name "*.mp3" -print -quit)
    [ -n "$DOWNLOADED_FILE" ] && touch "$DOWNLOADED_FILE"
    open "shortcuts://run-shortcut?name=Download-YT&input=spotify"
fi
