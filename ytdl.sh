#!/bin/sh

# --- DEBUGGING START ---
echo "--- Script Debug Info ---"
echo "Argument 1 (\$1): '$1'"
echo "Argument 2 (\$2): '$2'"
echo "Number of arguments (\$#): $#"
echo "All arguments (\$@): '$@'"
echo "--- End Debug Info ---"
# --- DEBUGGING END ---


# Ensure dependencies are installed and up to date
echo "Checking dependencies..."

# Check if yt-dlp is installed
if ! command -v yt-dlp >/dev/null 2>&1; then
    echo "yt-dlp not found. Installing..."
    pip install yt-dlp --break-system-packages
else
    echo "yt-dlp found. Updating..."
    pip install --upgrade yt-dlp --break-system-packages
fi

# Check if ffmpeg is installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "ffmpeg not found. Please install ffmpeg manually (e.g., via Homebrew on macOS or a package manager on Linux)."
    exit 1
else
    echo "ffmpeg found."
fi

# Ensure Pipe folder exists:
mkdir -p ~/Documents/Pipe

# Define the output directory once for clarity
OUTPUT_DIR="$HOME/Documents/Pipe"

# Get the URL from the first argument
URL="$1"
# Get the download mode from the second argument
MODE="$2"

# Handle different download modes
if [ "$MODE" = "audio" ]; then
    echo "Downloading audio..."
    # Download audio as opus
    yt-dlp -f bestaudio -o "$OUTPUT_DIR/%(title)s.opus" "$URL"

    # Update the modification date of the downloaded file to the current time.
    # This is less critical for VLC but included for consistency if needed for general file management.
    DOWNLOADED_FILE=$(find "$OUTPUT_DIR" -maxdepth 1 -name "*.opus" -print -quit)
    if [ -n "$DOWNLOADED_FILE" ]; then
        touch "$DOWNLOADED_FILE"
        echo "Updated modification date of '$DOWNLOADED_FILE' to current time."
    else
        echo "Warning: Could not find the downloaded Opus file to update its timestamp."
    fi

    # Original open command: pass 'vlc' to the shortcut
    open "shortcuts://run-shortcut?name=Download-YT&input=vlc"

elif [ "$MODE" = "video" ]; then
    # Check if the URL is an iFunny link
    if echo "$URL" | grep -q "ifunny.co"; then
        echo "iFunny link detected. Downloading efficiently for Photos."

        # Temporary name for the file downloaded by yt-dlp.
        # Using a fixed prefix to easily find it later.
        # Ensure the extension is always .mp4 for the iFunny case as recode-video mp4 is used.
        YT_DLP_OUTPUT_TEMP_PREFIX="yt-dlp_temp_"
        YT_DLP_OUTPUT_TEMP_PATH="$OUTPUT_DIR/${YT_DLP_OUTPUT_TEMP_PREFIX}%(title)s.mp4"

        # Download the video using yt-dlp to a temporary name
        yt-dlp "$URL" -f "best[ext=mp4][height<=720]/best" --recode-video mp4 -o "$YT_DLP_OUTPUT_TEMP_PATH"

        # Find the actual downloaded file name, using the specific prefix and .mp4 extension
        DOWNLOADED_FILE_TEMP=$(find "$OUTPUT_DIR" -maxdepth 1 -name "${YT_DLP_OUTPUT_TEMP_PREFIX}*.mp4" -print -quit)

        if [ -n "$DOWNLOADED_FILE_TEMP" ]; then
            # Define the final processed file name (remove the temporary prefix)
            FINAL_FILENAME=$(basename "$DOWNLOADED_FILE_TEMP" | sed "s/^${YT_DLP_OUTPUT_TEMP_PREFIX}//")
            FINAL_FILE_PATH="$OUTPUT_DIR/$FINAL_FILENAME" # This is where the ffmpeg output will go

            echo "Processing video with ffmpeg to strip metadata and ensure current date."
            # Use ffmpeg to copy the video without metadata, overwriting if needed
            ffmpeg -i "$DOWNLOADED_FILE_TEMP" -map_metadata -1 -codec copy -y "$FINAL_FILE_PATH"

            # Check if ffmpeg was successful
            if [ $? -eq 0 ]; then
                echo "ffmpeg processed '$DOWNLOADED_FILE_TEMP' to '$FINAL_FILE_PATH'."
                # Remove the temporary file after successful ffmpeg processing
                rm "$DOWNLOADED_FILE_TEMP"

                # Now, touch the final file to ensure its modification date is current.
                # This is the file the Shortcut will find in the Pipe folder.
                touch "$FINAL_FILE_PATH"
                echo "Updated modification date of '$FINAL_FILE_PATH' to current time for Photos sorting."
            else
                echo "ffmpeg failed to process the video (exit code $?). Using original downloaded file for Photos."
                echo "Photos sorting might still be based on original date for this file."
                # If ffmpeg fails, still ensure the original temp file has a current timestamp
                # and the shortcut will find this file instead.
                touch "$DOWNLOADED_FILE_TEMP"
                # If ffmpeg failed, we need to rename the temp file to the final path,
                # so the shortcut finds the expected filename without the temp_ prefix.
                mv "$DOWNLOADED_FILE_TEMP" "$FINAL_FILE_PATH"
                echo "Renamed temporary file to '$FINAL_FILE_PATH' as ffmpeg failed."
            fi

            # Original open command: pass 'photos' to the shortcut
            # The shortcut will then look for the (now processed and touched) file in Pipe.
            open "shortcuts://run-shortcut?name=Download-YT&input=photos"

        else
            echo "Error: Could not find the downloaded iFunny MP4 file after yt-dlp download (looked for ${YT_DLP_OUTPUT_TEMP_PREFIX}*.mp4)."
            echo "Aborting date update and shortcut call for this file."
            exit 1
        fi

    else # Regular video link (not iFunny)
        echo "Regular video link. Downloading for VLC."
        # Download for VLC, preferring webm
        yt-dlp "$URL" -f bestvideo+bestaudio --merge-output-format webm -o "$OUTPUT_DIR/%(title)s.webm"

        # Update the modification date of the downloaded file to the current time.
        # This is less critical for VLC but included for consistency if needed for general file management.
        DOWNLOADED_FILE=$(find "$OUTPUT_DIR" -maxdepth 1 -name "*.webm" -print -quit)
        if [ -n "$DOWNLOADED_FILE" ]; then
            touch "$DOWNLOADED_FILE"
            echo "Updated modification date of '$DOWNLOADED_FILE' to current time."
        else
            echo "Warning: Could not find the downloaded WebM file to update its timestamp."
        fi

        # Original open command: pass 'vlc' to the shortcut
        open "shortcuts://run-shortcut?name=Download-YT&input=vlc"
    fi

elif [ "$MODE" = "spotify" ]; then
    echo "Downloading Spotify audio as MP3..."
    # Download Spotify audio as MP3
    yt-dlp --extract-audio --audio-format mp3 -o "$OUTPUT_DIR/%(title)s.mp3" "$URL"

    # Update the modification date of the downloaded file to the current time.
    DOWNLOADED_FILE=$(find "$OUTPUT_DIR" -maxdepth 1 -name "*.mp3" -print -quit)
    if [ -n "$DOWNLOADED_FILE" ]; then
        touch "$DOWNLOADED_FILE"
        echo "Updated modification date of '$DOWNLOADED_FILE' to current time."
    else
        echo "Warning: Could not find the downloaded MP3 file to update its timestamp."
    fi

    # Original open command: pass 'spotify' to the shortcut
    open "shortcuts://run-shortcut?name=Download-YT&input=spotify"

else
    echo "Invalid option: $MODE"
    echo "Usage: script.sh <url> <audio|video|spotify>"
    exit 1
fi
