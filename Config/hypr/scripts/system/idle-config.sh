#!/bin/bash
# Configuración de swayidle
swayidle -w \
	timeout 1200 'swaylock-fancy' \
	timeout 1800 'systemctl suspend' \
	timeout 3600 'systemctl hibernate'
