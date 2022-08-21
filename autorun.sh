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
[ $(hostname) = 'artemis' ] && run org.ferdium.Ferdium
[ $(hostname) = 'artemis' ] && run kdeconnect-indicator
[ $(hostname) = 'artemis' ] && run pcmanfm -d
[ $(hostname) = 'themis' ] && run teams
run deezer
[ $(hostname) = 'artemis' ] && run gammastep-indicator
[ $(hostname) = 'artemis' ] && run picom
[ $(hostname) = 'artemis' ] && run flameshot
run rsibreak
[ $(hostname) = 'artemis' ] && run /opt/KopiaUI/kopia-ui
[ $(hostname) = 'artemis' ] && run megasync
[ $(hostname) = 'artemis' ] && run telegram-desktop
[ $(hostname) = 'themis' ] && run keepassxc
[ $(hostname) = 'themis' ] && run slack

xwallpaper --zoom "$HOME/.background-image"
