# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# history settings
HISTSIZE= HISTFILESIZE=  # don't ever discard history
HISTCONTROL=ignoreboth  # don't save duplicate lines or lines starting with space
shopt -s histappend  # append, don't overwrite history

# bash settings
shopt -s checkwinsize  # resize LINES and COLUMNS after each command
shopt -s globstar  # enable ** to match in subdirectories
stty -ixon  # disable ctrl-s freeze
shopt -s autocd  # cd when typing directory name

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias egrep='grep --color=auto'
    alias fgrep='grep --color=auto'
fi

# include aliases
if [ -d ~/.config/bash ]; then
    for file in ~/.config/bash/*; do
	. $file
    done
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# prompt
PS1="\w\$ "

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($HOME'/.local/etc/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/.local/etc/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/.local/etc/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/.local/etc/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

