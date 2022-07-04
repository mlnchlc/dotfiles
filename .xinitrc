xrandr --output eDP --right-of HDMI-A-0
xss-lock --transfer-sleep-lock -- i3lock --nofork -b -c 6272A4 -e -f --no-unlock-indicator &
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
exec awesome
