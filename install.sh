#!/bin/sh

# fail on error, print commands
set -e
set -x

# prerequisites
## fresh ubuntu server installation
# - tested with groovy gorilla (20.10)

## clone this repo
# - mkdir ~/Projects
# - cd ~/Projects
# - git clone [this repo's url]
# - cd dotfiles

# remove server-specific packages (-> ubuntu minimal)
sudo apt update -y
sudo apt install git
which snap && sudo snap remove --purge lxd
sudo apt remove -y --auto-remove --purge cloud-init snapd ubuntu-server

# upgrade installed packages
sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
sudo apt autoremove -y

# set up some directories
## home directories and shortcuts (-p to resume when they already exist)
mkdir -p ~/Documents
mkdir -p ~/Pictures
mkdir -p ~/Downloads
mkdir -p ~/Videos
mkdir -p ~/Projects
mkdir -p  ~/Desktop

## mounts points for usb devices
sudo mkdir -p /mnt/external1 /mnt/external2 /mnt/usb1 /mnt/usb2

## directory for manually installed programs
mkdir -p ~/.local/etc ~/.local/bin
PATH="$HOME/.local/bin:$PATH"

## create empty configuration directories to prevent them being owned by stow
mkdir -p ~/.local/share/applications ~/.config ~/.config/Xresources

# remove swap entry from fstab, if no swap is configured (would lead to error message during boot)
test -z `swapon --show` && sudo sed -i '/swap/d' /etc/fstab

# install Source Code Pro font
SCP_FONT_DIR="$HOME/.local/share/fonts/SourceCodePro"
mkdir -p "$SCP_FONT_DIR"
git clone https://github.com/adobe-fonts/source-code-pro "$SCP_FONT_DIR"/source-code-pro
mv "$SCP_FONT_DIR"/source-code-pro/TTF/*.ttf "$SCP_FONT_DIR"
rm -rf "$SCP_FONT_DIR"/source-code-pro
unset SCP_FONT_DIR
sudo apt install -y fontconfig
fc-cache -f

# link configuration
## remove files to be replaced
test -f ~/.bashrc && rm ~/.bashrc
test -f ~/.profile && rm ~/.profile
test -f ~/.bash_logout && rm ~/.bash_logout
test -f ~/.bash_profile && rm ~/.bash_profile

## link config modules
sudo apt install stow
stow bash -t ~
stow dunst -t ~
stow i3 -t ~
stow i3status -t ~
stow nano -t ~
stow readline -t ~
stow rofi -t ~
stow urxvt -t ~
stow utils -t ~
stow X11 -t ~
stow xmodmap -t ~

# install necessary packages
sudo apt install -y i3 pulseaudio
sudo apt install -y xinit x11-xserver-utils
sudo apt install -y bash-completion man-db grep wget curl sed vim tree emacs acpi htop libnotify-bin numlockx pulseaudio pavucontrol pulseaudio-module-bluetooth bluez dunst rofi xclip scrot feh python3-notify2 arandr mpv youtube-dl wmctrl jq x11-utils ntfs-3g rxvt-unicode atril pandoc firefox thunar file-roller fonts-noto-mono mousepad

# install python
## download and miniconda3 installation
MINICONDA_FILE=Miniconda3-latest-Linux-x86_64.sh
MINICONDA_LINK=https://repo.anaconda.com/miniconda/$MINICONDA_FILE
wget $MINICONDA_LINK
bash $MINICONDA_FILE -bsp ~/.local/etc/miniconda3
rm $MINICONDA_FILE

## set up the installation
$HOME/.local/etc/miniconda3/bin/conda install -y python numpy matplotlib scikit-learn scipy numba jupyter seaborn beautifulsoup4

# set timezone
sudo timedatectl set-timezone Europe/Berlin

# check for missing gpu drivers and install recommended
sudo apt install -y ubuntu-drivers-common
recommended_driver=`ubuntu-drivers devices | sed -rn 's/^driver *: ([a-z0-9-]*) .*recommended$/\1/p'`
test -n "$recommended_driver" && sudo apt install -y "$recommended_driver"

# set x-terminal-emulator to urxvt-client
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $HOME/.local/bin/urxvt-client 100
sudo update-alternatives --set x-terminal-emulator $HOME/.local/bin/urxvt-client

# don't require password for sudo
echo $USER 'ALL=(ALL) NOPASSWD:ALL' | sudo tee >/dev/null /etc/sudoers.d/10-nopasswd
