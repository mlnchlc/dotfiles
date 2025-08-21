#!/usr/bin/env bash
# Almighty-ish: a single-file shell toolkit to toggle many popular macOS tweaks
# Inspired by the Almighty app (menu bar tweaks + workflows). This script
# offers a large subset via CLI. Some actions require macOS 12+ and/or sudo.
#
# Usage examples:
#   ./almighty.sh list
#   ./almighty.sh hidden-files toggle
#   ./almighty.sh desktop-icons off
#   ./almighty.sh dark-mode toggle
#   ./almighty.sh keep-awake start
#   ./almighty.sh workflow "hidden-files on; show-extensions on; dock-autohide on"
#
# Notes:
# - Finder/Dock/SystemUIServer restarts are performed automatically when needed.
# - "sudo"-requiring actions will prompt. Use with care.
# - Tested on macOS 12–15. Some defaults keys may change in future macOS.

set -euo pipefail

# ---------- helpers ----------
err() { echo "[!] $*" >&2; }
msg() { echo "[*] $*"; }
ok()  { echo "[✓] $*"; }

require_macos() {
  if [[ "${OSTYPE:-}" != darwin* ]]; then
    err "This script only supports macOS."; exit 1
  fi
}

restart_finder()  { killall Finder  >/dev/null 2>&1 || true; }
restart_dock()    { killall Dock    >/dev/null 2>&1 || true; }
restart_ui()      { killall SystemUIServer >/dev/null 2>&1 || true; }

bool_arg() {
  local v=${1:-}
  case "$v" in
    on|true|1|yes) echo true ;;
    off|false|0|no) echo false ;;
    *) err "Expected on/off (got: $v)"; return 1 ;;
  esac
}

# Toggle helper: given domain key, flips bool and prints new state
_toggle_default() {
  local domain=$1 key=$2; shift 2
  local current
  current=$(defaults read "$domain" "$key" 2>/dev/null || echo 0)
  if [[ "$current" == 1 || "$current" == true ]]; then
    defaults write "$domain" "$key" -bool false
    echo off
  else
    defaults write "$domain" "$key" -bool true
    echo on
  fi
}

# ---------- commands ----------
cmd_list() {
  cat <<EOF
Available commands:
  hidden-files    [on|off|toggle]    — Show/hide hidden files in Finder
  desktop-icons   [on|off|toggle]    — Show/hide Desktop icons
  finder-quit     [on|off]           — Enable Finder "Quit" menu
  finder-restart                      — Restart Finder
  show-full-path  [on|off]           — Show full POSIX path in Finder title
  show-extensions [on|off]           — Show all filename extensions
  screenshots-location <path>        — Change screenshots save folder
  screenshots-format  <png|jpg|gif|tiff|pdf>
  dock-autohide   [on|off|toggle]    — Dock auto-hide
  dock-autohide-delay [0|default]    — Set Dock autohide delay (0 for instant)
  dock-magnify    [on|off|toggle]    — Dock magnification
  dock-size       <float 16–128>     — Dock icon size in points
  dock-recent     [on|off]           — Show recent apps in Dock
  dock-transparent-hidden [on|off]   — Make hidden apps translucent
  dock-add-spacer [apps|others] [n]  — Add n spacers to Dock
  dock-reset                          — Reset Dock to defaults (dangerous)
  dark-mode       [on|off|toggle]
  keep-awake      [start|stop]       — Use caffeinate to prevent sleep
  display-sleep                        — Turn off display immediately
  mute            [on|off|toggle]
  volume          <0–100>            — Set output volume %
  airdrop-all     [on|off]           — Allow AirDrop over all interfaces
  gatekeeper      [on|off]           — Enable/disable app verification (sudo)
  dns-flush                            — Flush DNS cache (sudo on older macOS)
  reduce-animations [on|off]         — Disable common UI animations
  restart-systemui                    — Restart SystemUIServer
  workflow        "cmd1; cmd2; ..."  — Run a semicolon-separated batch
  list                                 — Show this list
  help                                 — Show this list
EOF
}

cmd_hidden_files() {
  local action=${1:-};
  case "$action" in
    on|off)
      defaults write com.apple.finder AppleShowAllFiles -bool "$(bool_arg "$action")"
      restart_finder; ok "Hidden files: $action" ;;
    toggle)
      local state; state=$(_toggle_default com.apple.finder AppleShowAllFiles)
      restart_finder; ok "Hidden files: $state" ;;
    *) err "Usage: hidden-files [on|off|toggle]"; return 1 ;;
  esac
}

cmd_desktop_icons() {
  local action=${1:-}
  case "$action" in
    on|off)
      defaults write com.apple.finder CreateDesktop -bool "$(bool_arg "$action")"
      restart_finder; ok "Desktop icons: $action" ;;
    toggle)
      local state; state=$(_toggle_default com.apple.finder CreateDesktop)
      restart_finder; ok "Desktop icons: $state" ;;
    *) err "Usage: desktop-icons [on|off|toggle]"; return 1 ;;
  esac
}

cmd_finder_quit() {
  local action=${1:-}
  defaults write com.apple.finder QuitMenuItem -bool "$(bool_arg "$action")"
  restart_finder; ok "Finder Quit menu: $action"
}

cmd_finder_restart() { restart_finder; ok "Finder restarted"; }

cmd_show_full_path() {
  local action=${1:-}
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool "$(bool_arg "$action")"
  restart_finder; ok "Finder title shows full path: $action"
}

cmd_show_extensions() {
  local action=${1:-}
  defaults write NSGlobalDomain AppleShowAllExtensions -bool "$(bool_arg "$action")"
  restart_finder; ok "Show all filename extensions: $action"
}

cmd_screenshots_location() {
  local dir=${1:-}
  [[ -z "$dir" ]] && { err "Provide a directory"; return 1; }
  mkdir -p "$dir"
  defaults write com.apple.screencapture location "$dir"
  restart_ui; ok "Screenshots will save to: $dir"
}

cmd_screenshots_format() {
  local fmt=${1:-}
  case "$fmt" in png|jpg|gif|tiff|pdf) : ;; *) err "Format must be png|jpg|gif|tiff|pdf"; return 1;; esac
  defaults write com.apple.screencapture type -string "$fmt"
  restart_ui; ok "Screenshots format: $fmt"
}

cmd_dock_autohide() {
  local action=${1:-}
  case "$action" in
    on|off) defaults write com.apple.dock autohide -bool "$(bool_arg "$action")" ;killall Dock;;
    toggle) _toggle_default com.apple.dock autohide >/dev/null ;killall Dock ;;
    *) err "Usage: dock-autohide [on|off|toggle]"; return 1 ;;
  esac
  restart_dock; ok "Dock autohide: ${action}"
}

cmd_dock_autohide_delay() {
  local action=${1:-}
  case "$action" in
    0) defaults write com.apple.dock autohide-delay -float 0;restart_dock; ok "Dock autohide delay set to 0 (instant)" ;;
    default) defaults delete com.apple.dock autohide-delay 2>/dev/null || true;restart_dock; ok "Dock autohide delay reset to default" ;;
    *) err "Usage: dock-autohide-delay [0|default]"; return 1 ;;
  esac
}

cmd_dock_magnify() {
  local action=${1:-}
  case "$action" in
    on|off) defaults write com.apple.dock magnification -bool "$(bool_arg "$action")" ;;
    toggle) _toggle_default com.apple.dock magnification >/dev/null ;;
    *) err "Usage: dock-magnify [on|off|toggle]"; return 1 ;;
  esac
  restart_dock; ok "Dock magnification: ${action}"
}

cmd_dock_size() {
  local size=${1:-}
  [[ -z "$size" ]] && { err "Provide a size between 16–128"; return 1; }
  defaults write com.apple.dock tilesize -float "$size"
  restart_dock; ok "Dock size set to $size"
}

cmd_dock_recent() {
  local action=${1:-}
  defaults write com.apple.dock show-recents -bool "$(bool_arg "$action")"
  restart_dock; ok "Dock recent apps: $action"
}

cmd_dock_transparent_hidden() {
  local action=${1:-}
  defaults write com.apple.dock showhidden -bool "$(bool_arg "$action")"
  restart_dock; ok "Hidden apps translucent in Dock: $action"
}

cmd_dock_add_spacer() {
  local kind=${1:-apps} n=${2:-1}
  local tileType
  case "$kind" in
    apps)   tileType="spacer-tile" ;;
    others) tileType="small-spacer-tile" ;;
    *) err "Usage: dock-add-spacer [apps|others] [n]"; return 1 ;;
  esac
  for _ in $(seq 1 "$n"); do
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="'$tileType'";}'
  done
  restart_dock; ok "Added $n $kind spacer(s)"
}

cmd_dock_reset() {
  defaults delete com.apple.dock persistent-apps 2>/dev/null || true
  defaults delete com.apple.dock persistent-others 2>/dev/null || true
  restart_dock; ok "Dock reset to defaults"
}

cmd_dark_mode() {
  local action=${1:-}
  case "$action" in
    on)      osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true' ;;
    off)     osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false' ;;
    toggle)  osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode' ;;
    *) err "Usage: dark-mode [on|off|toggle]"; return 1 ;;
  esac
  ok "Dark mode: $action"
}

CAFFEINATE_PID_FILE="${TMPDIR:-/tmp}almighty_caffeinate.pid"
cmd_keep_awake() {
  local action=${1:-}
  case "$action" in
    start)
      if [[ -f "$CAFFEINATE_PID_FILE" ]] && kill -0 $(cat "$CAFFEINATE_PID_FILE") 2>/dev/null; then
        ok "Already keeping awake (pid $(cat "$CAFFEINATE_PID_FILE"))"; return 0
      fi
      nohup caffeinate -dimsu >/dev/null 2>&1 & echo $! > "$CAFFEINATE_PID_FILE"
      ok "Keep-awake started (pid $(cat "$CAFFEINATE_PID_FILE"))" ;;
    stop)
      if [[ -f "$CAFFEINATE_PID_FILE" ]]; then
        kill $(cat "$CAFFEINATE_PID_FILE") 2>/dev/null || true
        rm -f "$CAFFEINATE_PID_FILE"
        ok "Keep-awake stopped"
      else
        ok "Keep-awake was not running"
      fi ;;
    *) err "Usage: keep-awake [start|stop]"; return 1 ;;
  esac
}

cmd_display_sleep() {
  pmset displaysleepnow || { err "pmset failed"; return 1; }
  ok "Display turned off"
}

cmd_mute() {
  local action=${1:-}
  case "$action" in
    on)     osascript -e 'set volume output muted true' ;;
    off)    osascript -e 'set volume output muted false' ;;
    toggle) osascript -e 'set volume output muted not (output muted of (get volume settings))' ;;
    *) err "Usage: mute [on|off|toggle]"; return 1 ;;
  esac
  ok "Mute: $action"
}

cmd_volume() {
  local pct=${1:-}
  [[ -z "$pct" ]] && { err "Provide volume 0–100"; return 1; }
  # macOS volume has 0..7 steps; map percentage roughly
  local step=$(( (pct*7 + 50)/100 ))
  osascript -e "set volume output volume $pct --100%" 2>/dev/null || true
  osascript -e "set volume output volume $((pct))" >/dev/null
  ok "Volume set to ${pct}% (approx step ${step}/7)"
}

cmd_airdrop_all() {
  local action=${1:-}
  defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool "$(bool_arg "$action")"
  restart_finder; ok "AirDrop over all interfaces: $action"
}

cmd_gatekeeper() {
  local action=${1:-}
  case "$action" in
    on)  sudo spctl --master-enable ; ok "Gatekeeper enabled" ;;
    off) sudo spctl --master-disable; ok "Gatekeeper disabled (⚠︎ less secure)" ;;
    *) err "Usage: gatekeeper [on|off]"; return 1 ;;
  esac
}

cmd_dns_flush() {
  if killall -HUP mDNSResponder 2>/dev/null; then
    ok "Flushed DNS (mDNSResponder)"
  else
    sudo dscacheutil -flushcache || true
    ok "Attempted DNS flush via dscacheutil"
  fi
}

cmd_reduce_animations() {
  local action=${1:-}
  local b; b=$(bool_arg "$action")
  defaults write -g NSAutomaticWindowAnimationsEnabled -bool "$b"
  defaults write -g NSScrollAnimationEnabled -bool "$b"
  defaults write com.apple.dock launchanim -bool "$b"
  defaults write com.apple.dock autohide-time-modifier -float 0
  defaults write com.apple.finder DisableAllAnimations -bool "$b"
  restart_dock; restart_finder; ok "Reduced animations: $action (relogin may be needed)"
}

cmd_restart_systemui() { restart_ui; ok "SystemUIServer restarted"; }

cmd_workflow() {
  local seq=${1:-}
  [[ -z "$seq" ]] && { err "Provide a quoted list of semicolon-separated commands"; return 1; }
  IFS=';' read -r -a items <<< "$seq"
  for item in "${items[@]}"; do
    # shellcheck disable=SC2086
    ./"$(basename "$0")" $item || { err "Workflow step failed: $item"; exit 1; }
  done
}

# ---------- routing ----------
main() {
  require_macos
  local cmd=${1:-help}; shift || true
  case "$cmd" in
    list|help)               cmd_list ;;
    hidden-files)            cmd_hidden_files "$@" ;;
    desktop-icons)           cmd_desktop_icons "$@" ;;
    finder-quit)             cmd_finder_quit "$@" ;;
    finder-restart)          cmd_finder_restart ;;
    show-full-path)          cmd_show_full_path "$@" ;;
    show-extensions)         cmd_show_extensions "$@" ;;
    screenshots-location)    cmd_screenshots_location "$@" ;;
    screenshots-format)      cmd_screenshots_format "$@" ;;
    dock-autohide)           cmd_dock_autohide "$@" ;;
    dock-autohide-delay)     cmd_dock_autohide_delay "$@" ;;
    dock-magnify)            cmd_dock_magnify "$@" ;;
    dock-size)               cmd_dock_size "$@" ;;
    dock-recent)             cmd_dock_recent "$@" ;;
    dock-transparent-hidden) cmd_dock_transparent_hidden "$@" ;;
    dock-add-spacer)         cmd_dock_add_spacer "$@" ;;
    dock-reset)              cmd_dock_reset ;;
    dark-mode)               cmd_dark_mode "$@" ;;
    keep-awake)              cmd_keep_awake "$@" ;;
    display-sleep)           cmd_display_sleep ;;
    mute)                    cmd_mute "$@" ;;
    volume)                  cmd_volume "$@" ;; 
  esac
}
main "$@"


