#!/bin/bash

PATH=/usr/bin

TRACKS_DIR=$HOME/tracks.py
MUSIC_LIB_DIR=$HOME/music-library
SPOTIFY_USERNAME=becoming_yolo
EXPORT_FILENAME=spotify_export.csv
LOG_DIR=$HOME/log

$TRACKS_DIR/tracks.py/tracks.py -s -u $SPOTIFY_USERNAME -o $MUSIC_LIB_DIR 2>> $LOG_DIR/pull_spotify_library.log
cd $MUSIC_LIB_DIR
if [ $(git diff | wc -l) -gt 0 ]; then
    git add $EXPORT_FILENAME
    git commit -m "Spotify export $(date +%Y-%m-%d)"
    git push origin master
fi
