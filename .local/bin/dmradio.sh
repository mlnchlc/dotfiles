#!/usr/bin/env bash
#
# Script name: dm-radio
# Description: Choose between online radio stations with dmenu.
# Dependencies: dmenu, mpv, notify-send
# Forked from DT's GitLab: https://www.gitlab.com/dwt1/dmscripts

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
  stations["SomaFM -  Deep Space One"]="http://ice1.somafm.com/deepspaceone-128-aac"
  stations["SomaFM - Space Station Soma"]="http://ice1.somafm.com/spacestation-256-mp3"
  stations["SomaFM - Drone Zone"]="http://ice1.somafm.com/dronezone-256-mp3"
  stations["SomaFM - Suburbs of Goa"]="http://somafm.com/suburbsofgoa130.pls"
  stations["Listen.moe"]="https://listen.moe/stream"
  # stations[""] = ""

menu() {
  printf '%s\n' "Quit"
  # As this is loaded from other file it is technically not defined.
  # shellcheck disable=SC2154
  printf '%s\n' "${!stations[@]}" | sort
}

# Functions for sending notification messages
start_radio() {
  notify-send "Starting dm-radio" "Playing station: $1. 🎶"
}

end_radio() {
  notify-send "Stopping dm-radio" "You have quit dm-radio. 🎶"
}

main() {
  # Choosing a radio station from array sourced in 'config'.
  choice=$(menu | rofi -dmenu 'Choose radio station:' "$@") || exit 1

  case $choice in
    Quit)
      end_radio ;
      pkill -f "mpv http"
      exit
      ;;
    *)
      pkill -f "mpv http" || echo "mpv not running."
      start_radio "$choice" ;
      mpv "${stations["${choice}"]}"
      return
      ;;
  esac

}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
