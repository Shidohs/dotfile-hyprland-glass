#!/bin/bash

case "$1" in
--check)
    pacman -Qu >/dev/null 2>&1 && pacman -Qu | wc -l | xargs -I{} echo '{}' || pacman -Qq | wc -l | xargs -I{} echo '{}'
    ;;
--update)
    sakura -e sudo pacman -Syyu --noconfirm && notify-send "Update done" && pkill -SIGRTMIN+8 waybar
    exit 0
    ;;
esac
