#
# ~/.bash_profile
#
[[ -f ~/.bashrc ]] && . ~/.bashrc
PATH=$PATH:~/local/bin

export PATH=$PATH:~/.local/bin
export BROWSER=firefox
export XDG_CURRENT_DESKTOP=sway
export EDITOR=nvim
export PROMPT_COMMAND='history -a;history -c;history -r' # log history across multiple terminal instances without having to exit

export QT_QPA_PLATFORMTHEME=qt5ct

# if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  # exec startx
# fi

