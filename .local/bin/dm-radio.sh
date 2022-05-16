#!/usr/bin/env bash
#
# Script name: dm-radio
# Description: Choose between online radio stations with dmenu.
# Dependencies: dmenu, mpv, notify-send, playerctl
# Forked from DT's script: https://www.gitlab.com/dwt1/dmscripts
#
# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.
set -euo pipefail

_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd "$(dirname "$(readlink "${BASH_SOURCE[0]}" || echo ".")")" && pwd)"

declare -A stations 

stations["Radio Paradise - Main Mix"]="http://stream-uk1.radioparadise.com/aac-320"
stations["Radio Paradise - Rock Mix"]="http://stream.radioparadise.com/rock-320"
stations["Radio Paradise - Mellow Mix"]="http://stream.radioparadise.com/mellow-320"
stations["Radio Paradise - World/Etc Mix"]="https://stream.radioparadise.com/world-etc-320"
stations["Radio Caprice - Industrial/Dark/Ritual/Ambient"]="http://79.120.39.202:9095/"
stations["Radio Caprice - Post Rock"]="http://79.111.14.76:8004/postrock"
stations["SomaFM - Groove Salad"]="http://ice1.somafm.com/groovesalad-256-mp3"
stations["SomaFM - Deep Space One"]="http://ice1.somafm.com/deepspaceone-128-aac"
stations["SomaFM - n5md"]="https://somafm.com/n5md130.pls"
stations["SomaFM - Space Station Soma"]="http://ice1.somafm.com/spacestation-128-aac"
stations["SomaFM - Drone Zone"]="http://ice1.somafm.com/dronezone-256-mp3"
stations["SomaFM - Suburbs of Goa"]="http://somafm.com/suburbsofgoa130.pls"
stations["Listen.Moe"]="https://listen.moe/stream"
stations["Bongonet - Bangla Rock"]="https://www.bongonet.net/banglarock"
stations["Cryo Chamber"]="ytdl://ytsearch:'Cryo Chamber Radio'"
stations["Lofi Girl"]="ytdl://ytsearch:'Lofi Girl Radio'"
stations["BBC Radio 1Xtra"]="https://stream.live.vc.bbcmedia.co.uk/bbc_1xtra"
stations["Classical KDFC"]="https://playerservices.streamtheworld.com/api/livestream-redirect/KDFCFMAAC.aac"
stations["TuneIn - Hot Hip Hop and R&B"]="http://tunein4.streamguys1.com/hhhrbfree1"
stations["Hot 108 Jamz"]="http://sc.hot108.com:4000/"
stations["Hunter FM - LoFi"]="https://live.hunter.fm/lofi_high"
stations["Your Classical - Peaceful Piano"]="http://peacefulpiano.stream.publicradio.org/peacefulpiano.mp3"
#

menu() {
  printf '%s\n' "Quit"
  printf '%s\n' "${!stations[@]}" | sort
}

# Functions for sending notification messages
notify_start() {
  notify-send "Starting dm-radio" "Playing station: $1. 🎶"
}

notify_end() {
  notify-send "Stopping dm-radio" "You have quit dm-radio. 🎶"
}

kill_running_media() {
  if [ "$(playerctl status)" == "Playing" ]; then
      killall mpv;
    # playerctl -a stop;
  fi
}

main() {
  choice=$(menu | dmenu -i -p 'Choose radio station' "$@") || exit 1
  case $choice in
    Quit)
      kill_running_media;
      notify_end;
      exit
      ;;
    *)
      kill_running_media;
      notify_start "$choice" ;
      mpv --no-resume-playback --no-video "${stations["${choice}"]}"
      return
      ;;
  esac

}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
