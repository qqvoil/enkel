#!/usr/bin/env bash

url=$(playerctl -p spotify metadata mpris:artUrl 2>/dev/null)

if [[ -z "$url" ]]; then
    rm -f /tmp/spotify_cover.png
    exit 0
fi

if [[ -f "/tmp/spotify_cover_url.txt" ]]; then
    last_url=$(cat "/tmp/spotify_cover_url.txt")
else
    last_url=""
fi

if [[ "$url" != "$last_url" || ! -f "/tmp/spotify_cover.png" ]]; then
    if [[ "$url" == file://* ]]; then
        magick "${url#file://}" -resize 22x22^ -gravity center -extent 22x22 /tmp/spotify_cover.png
    else
        curl -s "$url" -o /tmp/spotify_dl.png
        magick /tmp/spotify_dl.png -resize 22x22^ -gravity center -extent 22x22 /tmp/spotify_cover.png
    fi
    echo "$url" > "/tmp/spotify_cover_url.txt"
fi

echo "/tmp/spotify_cover.png"
