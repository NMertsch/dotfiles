#!/bin/bash
# incorporated tools: scrot, xclip, dmenu, notify-send, feh (can be replaced easily, e.g. by sxiv)

temp_fname="$(mktemp).png"
image_viewer_manual="feh --scale-down --title screenshot_viewer"
image_viewer_full="feh --scale-down"

# menu: screenshot mode
if [[ "$1" = "-s" ]]; then
    selection="manual"
else
    selection=$(echo "window manual screen" | tr " " "\n" | dmenu -i -p "Screenshot")
fi

[[ "$selection" = "" ]] && exit

if [[ "$selection" = "manual" ]]; then
    sel_cmd="-s"
elif [[ "$selection" = "window" ]]; then
    sel_cmd="-u"
elif [[ "$selection" = "screen" ]]; then
    sel_cmd=""
fi

# take screenshot
sleep 0.2  # needed to load glib resources, but can be shortened depending on system
err=$(scrot $sel_cmd $temp_fname 2>&1 >/dev/null)

# error handling
key_abort=$(echo "$err" | grep -o "Key was pressed")
[[ ! "$key_abort" = "" ]] && exit
[[ ! "$err" = "" ]] && notify-send "Failed to take screenshot" "$err" -u critical

# menu: action
target=$(echo "clipboard save show" | tr " " "\n" | dmenu -i -p "Action")
[[ "$target" = "" ]] && exit

if [[ "$target" = "clipboard" ]]; then
    xclip -selection c -t image/png < $temp_fname
    rm $temp_fname
elif [[ "$target" = "show" ]]; then
    if [[ "$selection" = "manual" ]]; then
        $image_viewer_manual $temp_fname
    else
        $image_viewer_full $temp_fname
    fi
    rm $temp_fname
elif [[ "$target" = "save" ]]; then
    save_path="$HOME/Pictures/screenshots/"
    [[ ! -d "$save_path" ]] && mkdir -p "$save_path"
    default_fname="screenshot_$(date '+%Y-%m-%d-%T')"
    fname=$(echo "$default_fname" | dmenu -i -p "Save to $save_path")
    [[ "$fname" = "" ]] && exit
    if [ ! $(cat "$fname" | grep "\.png$") ]; then
        fname="${fname}.png"
    fi
    err=$(mv $temp_fname "$save_path/$fname" 2>&1 >/dev/null)
    if [[ ! "$err" = "" ]]; then
        notify-send "Failed to save screenshot, saved it as $(readlink -f $temp_fname)" "$err" -u critical
    fi
fi
