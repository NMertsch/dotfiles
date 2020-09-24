#!/bin/bash

# A dmenu prompt to unmount drives.
# Provides you with mounted partitions, select one to unmount.

mount_dirs="/mnt/|/media/"

drives=$(lsblk -lp | grep "part */" | awk '{print $1, "(" $4 ")", on, $7'} | grep -P " (/mnt|/media)")
if [[ "$drives" = "" ]]; then
    pgrep -x dunst && notify-send "no unmountable drive found"
    exit
fi

chosen=$(echo $drives | dmenu -i -p "Unmount which drive?" | awk '{print $1}')
[[ "$chosen" = "" ]] && exit

err=$(sudo umount $chosen 2>&1 >/dev/null)
if [[ "$err" = "" ]]; then
    pgrep -x dunst && notify-send "$chosen unmounted"
else
    pgrep -x dunst && notify-send "$err" -u critical
fi
