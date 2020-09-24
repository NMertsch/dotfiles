#!/bin/bash

# detect if one or two monitors are connected and set them up accordingly
# may lead to strange behaviour for three or more connected monitors

primary_monitor=$(xrandr --query | grep -P "\w* connected primary" | cut -d" " -f1)
non_primary_monitor=$(xrandr --query | grep -P "\w* connected [^p]" | cut -d" " -f1)
disconnected_monitors=$(xrandr --query | grep -P "\w* disconnected" | cut -d" " -f1)

if [[ -n $non_primary_monitor ]]; then
    xrandr --auto
    xrandr --output $primary_monitor --primary --left-of $non_primary_monitor
else
    for monitor in $non_primary_monitors; do
        xrandr --output $monitor --off
    done
    xrandr --auto
fi
