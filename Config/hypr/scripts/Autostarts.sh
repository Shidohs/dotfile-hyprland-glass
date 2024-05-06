#!/bin/bash

# function for reset {}
App=$1

reset() {
    pgrep -x "$App" && pkill -x "$App"
    $App &
}
case $2 in
"--dunst")
    reset
    ;;
"--waybar")
    reset
    ;;
esac
