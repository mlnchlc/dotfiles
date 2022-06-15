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



# start sway automatically on tty1 login
 if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec sway -d 2> ~/sway.log
fi

