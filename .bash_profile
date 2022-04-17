#
# ~/.bash_profile
#
[[ -f ~/.bashrc ]] && . ~/.bashrc
PATH=$PATH:~/local/bin

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

