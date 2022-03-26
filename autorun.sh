#!/usr/bin/env bash

run() {
  if ! pgrep -f "$1" ;
  then
    $@ &
  fi
}

run autorandr -c
run teams
run spotify
[ $(hostname) = 'artemis' ] && run megasync
[ $(hostname) = 'artemis' ] && run telegram-desktop
[ $(hostname) = 'artemis' ] && run discord
[ $(hostname) = 'themis' ] && run keepassxc
[ $(hostname) = 'themis' ] && run slack
