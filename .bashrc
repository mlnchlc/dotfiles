#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# funny
fortune -acos

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

alias ls='ls --color=auto'
alias less='less -N' # line numbering with less, why isn't it default?

alias firefox-throwaway='firefox -no-remote -profile $(mktemp -d)'
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME" #dotfile management using git bare repo
alias sync='syncthing serve --no-browser'
alias warp-check='curl https://www.cloudflare.com/cdn-cgi/trace/ | grep warp'

