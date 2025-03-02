#!/bin/sh

if [ "$2" = "video" ]; then
    yt-dlp -f bestvideo+bestaudio --merge-output-format webm -o ~/Documents/vlcPipe/"%(title)s.webm" "$1"
else
    yt-dlp -f bestaudio -o ~/Documents/vlcPipe/"%(title)s.opus" "$1"
fi

# Automatically trigger the Shortcut to move the file
open "shortcuts://run-shortcut?name=Download-YouTube&input=vlcPipe"
