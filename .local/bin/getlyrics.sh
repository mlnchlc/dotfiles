#!/usr/bin/env bash
#
# Script name: getlyrics
# Description: Get lyrics from azlyrics.com
# Dependencies: playerctl (and curl, awk, sed)

set -euo pipefail

# _path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd "$(dirname "$(readlink "${BASH_SOURCE[0]}" || echo ".")")" && pwd)"

useragent="Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0"
accept="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"


get_first_result(){
  song=$(echo "$@" | tr " " +)  # replaces space by + characters
  curl -s -L -H "User-Agent: $useragent" -H \
    "Accept: $accept"  https://search.azlyrics.com/search.php?q=$song | 
    awk '/<tr>/{flag=1;next}/<\/tr>/{flag=0}flag' |   # get search results which are between <tr> and </tr> tags
    awk -F "\"" '{print $2}' |    # extract href link by making " the field separator
    head -n 1
}

print_lyrics(){
  if [ "$1" == "" ]; then
    echo "No Lyrics found" && return 
  else 
    echo -e "$1\n"
  fi
  
  curl -s -L -H "User-Agent: $useragent" -H "Accept: $accept" $1 | 
    awk '/Usage of azlyrics.com/{flag=1;next}/<\/div>/{flag=0}flag' | # lyric data is between a comment and the next div. Real hacky, but pages are consistent
    sed  's/<[^>]*>//g' || echo "No lyrics found."  # remove remaining line break tags
}

get_playing_song() {
 playerctl metadata | awk '/title/{$1=$2="";print substr($0,3)}' # Prints all the fields from field 3. Stack Overflow to the rescue !
}

main() {
  prev_song=""
  while [ "$(playerctl status)" == "Playing" ]
  do
    curr_song="$(get_playing_song)"
    if [ "$curr_song" != "$prev_song" ]; then # when new song comes on
      clear;
      notify-send "Now Playing:$curr_song"
      echo $curr_song;
      song_url="https://azlyrics.com/lyrics/$(echo $curr_song | tr "[:upper:]" "[:lower:]" | tr "-" "/" | sed "s/ //g").html"
      echo $song_url;
      print_lyrics $song_url
    fi
    sleep 10s;
    prev_song=$curr_song
  done
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"


