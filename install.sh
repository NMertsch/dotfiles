#!/bin/sh

# prerequisites
## fresh ubuntu server installation
# - tested with groovy gorilla (20.10)

## install git
# - sudo apt update -y
# - sudo apt install -y git

## (optional) set up wireless networking
# - sudo apt install iwd dhcpcd5
# - iwctl  # (interactive command)
#   - station [WIRELESS] connect [ESSID]  # (e.g. station wlan0 connect MyWiFi)
#   - [PASSPHRASE]
# - sudo systemctl enable dhcpcd.service
# - sudo systemctl start dhcpcd.service

## clone this repo
# - mkdir ~/Projects
# - cd ~/Projects
# - git clone [this repo's url]

# remove server-specific packages (-> ubuntu minimal)
sudo apt update -y
sudo snap remove --purge lxd
sudo apt remove -y --auto-remove --purge clout-init snapd ubuntu-server

# upgrade installed packages
sudo apt full-upgrade -y
sudo apt autoremove -y

# set up some directories
## home directories and shortcuts
mkdir ~/Documents && ln -s $HOME/Documents $HOME/doc
mkdir ~/Pictures && ln -s $HOME/Pictures $HOME/pic
mkdir ~/Downloads && ln -s $HOME/Downloads $HOME/dl
mkdir ~/Videos && ln -s $HOME/Videos $HOME/vid
mkdir ~/Projects && ln -s $HOME/Projects $HOME/git
mkdir ~/Desktop

## mounts points for usb devices
sudo mkdir -p /mnt/external1 /mnt/external2 /mnt/usb1 /mnt/usb2

## directory for manually installed programs
mkdir -p ~/.local/etc ~/.local/bin
PATH="$HOME/.local/bin:$PATH"

## create empty configuration directories to prevent them being owned by stow
mkdir -p ~/.local/share/applications ~/.config ~/.config/xrdb

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


# install necessary packages
sudo apt install -y i3 pulseaudio
sudo apt install -y xinit x11-xserver-utils
sudo apt install -y bash-completion man-db grep wget curl sed vim tree emacs acpi htop libnotify-bin numlockx pulseaudio pavucontrol pulseaudio-module-bluetooth bluez dunst rofi xclip scrot feh python3-notify2 arandr mpv youtube-dl wmctrl jq x11-utils nfts-3g rxvt-unicode atril pandoc firefox thunar thunderbird cups libreoffice

# install python
## download and miniconda3 installation
MINICONDA_FILE=Miniconda3-latest-Linux-x86_64.sh
MINICONDA_LINK=https://repo.anaconda.com/miniconda/$MINICONDA_FILE
wget $MINICONDA_LINK
bash $MINICONDA_FILE -bsp ~/.local/etc/miniconda3
rm $MINICONDA_FILE

## set up the installation
$HOME/.local/etc/miniconda3/bin/conda init
$HOME/.local/etc/miniconda3/bin/conda install -y python numpy matplotlib scikit-learn scipy numba jupyter seaborn beautifulsoup4

