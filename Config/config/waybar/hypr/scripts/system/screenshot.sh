#!/bin/bash

# Verificar la existencia De la carpeta
dir="$(xdg-user-dir PICTURES)/Screenshot"

if [[ -d dir ]]; then
    mkdir -p "$dir"
fi

case "$1" in
--normal)
    scrot -s "$dir"/screenshot_$(date +%Y%m%d_%H%M%S).png
    ;;
--mouse)
    echo "item = 2 or item = 3"
    ;;
--ventana)
    echo "default (none of above)"
    ;;
esac
