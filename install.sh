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
sudo snap remove --purge lxd
tmp=`mktemp`
sudo apt remove -y --auto-remove --purge cloud-init snapd ubuntu-server | tee $tmp

# upgrade installed packages
sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
sudo apt autoremove -y

# set up some directories
## home directories and shortcuts (-p to resume when they already exist)
mkdir -p ~/Documents && ln -s $HOME/Documents $HOME/doc
mkdir -p ~/Pictures && ln -s $HOME/Pictures $HOME/pic
mkdir -p ~/Downloads && ln -s $HOME/Downloads $HOME/dl
mkdir -p ~/Videos && ln -s $HOME/Videos $HOME/vid
mkdir -p ~/Projects && ln -s $HOME/Projects $HOME/git
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
sudo apt install -y bash-completion man-db grep wget curl sed vim tree emacs acpi htop libnotify-bin numlockx pulseaudio pavucontrol pulseaudio-module-bluetooth bluez dunst rofi xclip scrot feh python3-notify2 arandr mpv youtube-dl wmctrl jq x11-utils ntfs-3g rxvt-unicode atril pandoc firefox thunar file-roller

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
