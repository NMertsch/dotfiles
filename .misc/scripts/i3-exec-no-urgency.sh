#!/bin/bash

prog=$1
if [ "$2" != "" ]; then
    window=$2
else
    window=$1
fi

if [ -z $(which "$prog") ]; then
    notify-send "$prog" "Cannot be executed, command not found." -t 3000
    exit 1
fi

# run and wait until started
i3-msg exec "$prog"
until [ ! -z $(wmctrl -lx | awk '{print $3}' | grep -i $prog) ]; do
    sleep 0.5
done

ws_info=$(i3-msg -t get_workspaces)
visible_unfocused_ws=$(echo $ws_info | jq '.[] | select(.visible==true and .focused==false).name')
visible_focused_ws=$(echo $ws_info | jq '.[] | select(.visible==true and .focused==true).name')

wmctrl -a $window
for ws in $visible_unfocused_ws; do
    i3-msg workspace $ws
done
i3-msg workspace $visible_focused_ws
