#!/bin/sh

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
    echo "ffmpeg not found. Please install ffmpeg manually."
    exit 1
else
    echo "ffmpeg found."
fi

# Ensure Pipe folder exists:
mkdir -p ~/Documents/Pipe

# Handle different download modes
if [ "$2" = "audio" ]; then
    yt-dlp -f bestaudio -o ~/Documents/Pipe/"%(title)s.opus" "$1"
    open "shortcuts://run-shortcut?name=Download-YT&input=vlc"
elif [ "$2" = "video" ]; then
    yt-dlp "$1" -f bestvideo+bestaudio --merge-output-format webm -o ~/Documents/Pipe/"%(title)s.webm"
    open "shortcuts://run-shortcut?name=Download-YT&input=vlc"
elif [ "$2" = "spotify" ]; then
    yt-dlp --extract-audio --audio-format mp3 -o ~/Documents/Pipe/"%(title)s.mp3" "$1"
    open "shortcuts://run-shortcut?name=Download-YT&input=spotify"
else
    echo "Invalid option: $2"
    echo "Usage: script.sh <url> <audio|video|spotify>"
    exit 1
fi
