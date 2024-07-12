#!/bin/bash

# Obtener el DNS más rápido
fastest_dns=$(resolvectl dns wlo1 | awk '/DNS Servers:/ {print $3}')

# Cambiar el DNS utilizando nmcli
sudo nmcli dev modify wlo1 ipv4.dns "$fastest_dns"

# Aplicar los cambios
sudo systemctl restart NetworkManager

echo "Se cambió el DNS a $fastest_dns"
