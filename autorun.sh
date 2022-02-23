#!/usr/bin/env bash

run() {
  if ! pgrep -f "$1" ;
  then
    $@ &
  fi
}

run autorandr -c
run megasync
[ $(hostname) = 'themis' ] && echo run keepassxc
