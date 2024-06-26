#!/bin/bash
# Version 1.3
# Bugfixes: Problemas con los indicadores Solucionado.
#Autor: Shidohs
#github: https://github.com/Shidohs

# Archivo JSON donde se guardarán los datos
pacman_json="$HOME/.config/waybar/scripts/system/pacman/pacman.json"

case "$1" in
--check)
    # Obtener el valor de "packages" y "updates" del archivo JSON
    packages=$(jq -r '.packages' "$pacman_json")
    updates=$(jq -r '.updates' "$pacman_json")

    #Verificar si "packages" y "updates" están vacíos o son 0
    if [ -z "$updates" ] || [ "$updates" -eq 0 ]; then
        if [ -z "$packages" ] || [ "$packages" -eq 0 ]; then
            echo "No packages or updates available"
        else
            echo "$packages" | xargs -I{} echo '{}'
        fi
    else
        echo "$updates" | xargs -I{} echo ' {}'
    fi
    ;;
--update)
    sakura -e sudo pacman -Syyu && notify-send "Update done" && pkill -SIGRTMIN+8 waybar
    exit 0
    ;;
esac
