# machine-dependent settings
case `hostname` in
    niklas-desktop)
        xrandr --output DP-1 --panning 1920x1080+0+0 --output HDMI-0 --primary --panning 2560x1440+1920+0 &
    ;;
    niklas-tp)
        which brightnessctl >/dev/null && brightnessctl s 30% >/dev/null
    ;;
esac

# merge all Xresources into xrdb
if [ -d ~/.config/Xresources ]; then
    tmp=`mktemp`
    cat ~/.config/Xresources/* > $tmp
    xrdb -merge $tmp
    rm $tmp
fi

# start davmail server if available
which davmail && davmail -server -notray >/dev/null 2>/dev/null &

# resolve GTK apps launching slowly
## https://bbs.archlinux.org/viewtopic.php?id=224787
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# apply key mapping
test -f ~/.config/xmodmap-`hostname`.conf && xmodmap ~/.config/xmodmap-`hostname`.conf

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
