#!/bin/bash

 sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal

 # Iniciar solo el portal específico de Hyprland
 /usr/lib/xdg-desktop-portal-hyprland &

# Esperar un poco antes de iniciar el portal genérico
sleep 2
 
 # Iniciar solo si realmente necesitas el portal genérico, en caso contrario, elimina esta línea
 # /usr/lib/xdg-desktop-portal &
