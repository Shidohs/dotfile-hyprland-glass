#!/bin/bash
# Version 1.2
#Autor: Shidohs
#github: https://github.com/Shidohs

# Archivo JSON donde se guardarán los datos
pacman_json="$HOME/.config/hypr/scripts/system/pacman.json"

case "$1" in
--check)
    # Obtener el valor de "packages" y "updates" del archivo JSON
    packages=$(jq -r '.packages' "$pacman_json")
    updates=$(jq -r '.updates' "$pacman_json")

    # Verificar si la variable "updates" está vacía
    if [ -z "$updates" ]; then
        # Si está vacía, imprimir "packages"
        echo "$packages" | xargs -I{} echo '{}'
    else
        # Si no está vacía, imprimir "updates"
        echo "$updates" | xargs -I{} echo ' {}'
    fi
    ;;
--update)
    sakura -e sudo pacman -Syyu && notify-send "Update done" && pkill -SIGRTMIN+8 waybar
    exit 0
    ;;
esac
