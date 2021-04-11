# Microsoft .NET telemetry opt-out
export DOTNET_CLI_TELEMETRY_OPTOUT=true

# XDG base directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"

export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

# for the programs ignoring XDG
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter

mkdir -p "$XDG_CONFIG_HOME"/less
export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey
export LESSHISTFILE="$XDG_CONFIG_HOME"/less/history

export DVDCSS_CACHE="$XDG_DATA_HOME"/dvdcss

# others
export EDITOR="nano"

# source .bashrc
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# add ~/bin to PATH
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# start i3 on tty-login
if [ "$(tty)" = "/dev/tty1" ] && [ -z $(pgrep -x i3)]; then
    exec startx
fi
