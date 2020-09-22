#!/bin/bash

cmd=$(echo "Lock Shutdown Reboot Suspend Logout" | tr " " "\n" | dmenu -i -p "Exit")
[[ "$cmd" = "" ]] && exit

if [[ "$cmd" = "Lock" ]]; then
    i3lock -c 2f343f
elif [[ "$cmd" = "Shutdown" ]]; then
    systemctl poweroff
elif [[ "$cmd" = "Suspend" ]]; then
    systemctl suspend
elif [[ "$cmd" = "Reboot" ]]; then
    systemctl reboot
elif [[ "$cmd" = "Logout" ]]; then
    i3-msg exit
fi
