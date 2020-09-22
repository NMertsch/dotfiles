#!/bin/bash

info=$(amixer -D pulse get Master)
volume=$(echo "$info" | grep -oP "\d*%" | head -n1)
muted=$(echo "$info" | grep -oP "\[(off|on)\]" | head -n1)
if [[ "$muted" = "[off]" ]]; then
    mute_state="(muted)"
else
    mute_state=""
fi

notification_id=9910

notify-send -t 750 "Volume: $volume $mute_state" -r "$notification_id" $@
