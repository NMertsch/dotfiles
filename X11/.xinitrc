# set display resolution
case `hostname` in
    niklas-desktop)
        xrandr --output DP-1 --panning 1920x1080+0+0 --output HDMI-0 --panning 2560x1440+1920+0 &
    ;;
esac

# merge all Xresources into xrdb
if [ -d ~/.config/Xresources ]; then
    for file in ~/.config/Xresources/*; do
        xrdb -merge $file
    done
fi

# enable numpad
which numlockx > /dev/null && numlockx on &

# start dunst daemon
which dunst > /dev/null && dunst &

# start urxvt daemon
urxvtd --fork --quiet --opendisplay

# notify for apt updates
(apt upgrade --simulate 2>/dev/null | tail -n1 | grep [1-9] && sleep 3 && notify-send "Updates available"  &)

# finally run i3
i3
