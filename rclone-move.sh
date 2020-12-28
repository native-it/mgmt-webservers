#!/usr/bin/env bash

# Last revised 2020-12-27
# Usage - $ sh rclone-move.sh -b [specify bandwidth limit as an integer MB/s]
# This script is designed to work in conjunction with Virtualmin's scheduled backups stored locally in /usr/share/backup/servers. When executed, this will
# take the files in the backup folder and move them to Backblaze B2 storage already configured.

# Set variables
RCLONE_CONFIG=/root/.config/rclone/rclone.conf
NOW=$(date +"%Y-%m-%d")
export RCLONE_CONFIG
export NOW

# Setup garbage collector to preserve memory
export GOGC=20

# Exit if script is already running
if [[ $(pidof -x "$0" | wc -w) -gt 2 ]]; then
    echo "$0 already running"
    exit
fi

# Show help message when using -h
usage()
{
    echo "usage: rclone-move.sh [-b | --bandwidth specify bandwidth as an integer | -h | --help shows this message]"
}

# Set bandwidth limit using -b
if [ "$1" != "" ]; then

BANDWIDTH=

while [ "$1" != "" ]; do
    case $1 in
        -b | --bandwidth )	shift
                                BANDWIDTH=$1
				export BANDWIDTH
                                ;;
        -h | --help )           usage
                                exit 0
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# Run rclone command using set bandwidth, otherwise default to 4M
bash -c 'rclone move --bwlimit "$BANDWIDTH"M --buffer-size 0M --transfers 1 --checkers 1 --log-file /usr/share/backup/log/rclone-move_$NOW.log /usr/share/backup/servers backblaze:HOST-WEB01/$NOW'
else
bash -c 'rclone move --bwlimit 4M --buffer-size 0M --transfers 1 --checkers 1 --log-file /usr/share/backup/log/rclone-move_$NOW.log /usr/share/backup/servers backblaze:HOST-WEB01/$NOW'
fi
