#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# funny
fortune -acos

# start sway automatically on tty1 login
# if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
#  exec sway -d 2> ~/sway.log
#fi

# prompt
COLOR_PROMPT_FULL="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
COLOR_PROMPT_MINIMAL="\[\033[01;32m\]\w\[\033[00m\]\$ "
PS1=$COLOR_PROMPT_MINIMAL

# search and play youtube video
function yt() {  
    mpv ytdl://ytsearch:"$*"	
}

# search and download only audio stream, doesn't work on livestreams
function ytm() {
    mpv --no-video --ytdl-format=bestaudio ytdl://ytsearch:"$*"  
}

#play only audio, but both audio and video get downloaded
function ytr() {
    mpv --no-video ytdl://ytsearch:"$*"		
}

function comp() {
    cp ~/Code/template.cpp ~/Code/"$1" && $EDITOR ~/Code/"$1"
}

function bp() {
    cp ~/Code/boilerplate.html ~/Code/"$1" && $EDITOR ~/Code/"$1"
}
alias ls='ls --color=auto'
alias sway='sway -d 2> ~/sway.log' 
alias firefox-throwaway='firefox -no-remote -profile $(mktemp -d)'
alias less='less -N' # line numbering with less, why isn't it default?
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME" #dotfile management using git bare repo
alias sync='syncthing serve --no-browser'
alias warp-check='curl https://www.cloudflare.com/cdn-cgi/trace/ | grep warp'

export PATH=$PATH:~/.local/bin
export BROWSER=firefox
export EDITOR=vim
export PROMPT_COMMAND='history -a;history -c;history -r' # log history across multiple terminal instances without having to exit

export QT_QPA_PLATFORMTHEME=qt5ct
