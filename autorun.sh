#!/usr/bin/env bash

run() {
  if ! pgrep -f "$1" ;
  then
    $@ &
  fi
}

run autorandr -c
run setxkbmap -option caps:escape
[ $(hostname) = 'artemis' ] && run nm-applet
[ $(hostname) = 'artemis' ] && run ferdium
[ $(hostname) = 'themis' ] && run teams
run spotify
[ $(hostname) = 'artemis' ] && run gammastep-indicator
[ $(hostname) = 'artemis' ] && run picom
[ $(hostname) = 'artemis' ] && run flameshot
run rsibreak
[ $(hostname) = 'artemis' ] && run /opt/KopiaUI/kopia-ui
[ $(hostname) = 'artemis' ] && run megasync
[ $(hostname) = 'artemis' ] && run telegram-desktop
[ $(hostname) = 'themis' ] && run keepassxc
[ $(hostname) = 'themis' ] && run slack
