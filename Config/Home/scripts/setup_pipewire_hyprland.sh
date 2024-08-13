#!/bin/bash

# Instalar PipeWire y sus componentes
echo "Instalando PipeWire..."
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack --noconfirm

# Habilitar los servicios de PipeWire
echo "Habilitando servicios de PipeWire..."
systemctl --user enable --now pipewire pipewire-pulse
# Verificar configuración
echo "Verificando instalación de PipeWire..."
pactl info

echo "Instalación y configuración completadas. Reinicia tu sistema para aplicar los cambios."
