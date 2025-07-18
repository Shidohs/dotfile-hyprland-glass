#!/bin/bash

# Script para gestionar Bluetooth desde Waybar
# Uso: ./bluetooth_manager.sh [action] [device_mac]

ACTION="$1"
DEVICE_MAC="$2"

case "$ACTION" in
    "toggle")
        # Alternar estado del Bluetooth
        if bluetoothctl show | grep -q "Powered: yes"; then
            bluetoothctl power off
            notify-send "Bluetooth" "Desactivado" -i bluetooth-off
        else
            bluetoothctl power on
            notify-send "Bluetooth" "Activado" -i bluetooth-on
        fi
        ;;
    
    "scan")
        # Iniciar escaneo
        bluetoothctl scan on &
        notify-send "Bluetooth" "Escaneando dispositivos..." -i bluetooth
        ;;
    
    "connect")
        # Conectar a un dispositivo específico
        if [[ -n "$DEVICE_MAC" ]]; then
            bluetoothctl connect "$DEVICE_MAC"
            notify-send "Bluetooth" "Conectando a dispositivo..." -i bluetooth
        fi
        ;;
    
    "disconnect")
        # Desconectar un dispositivo específico
        if [[ -n "$DEVICE_MAC" ]]; then
            bluetoothctl disconnect "$DEVICE_MAC"
            notify-send "Bluetooth" "Desconectando dispositivo..." -i bluetooth
        fi
        ;;
    
    "remove")
        # Eliminar un dispositivo emparejado
        if [[ -n "$DEVICE_MAC" ]]; then
            bluetoothctl remove "$DEVICE_MAC"
            notify-send "Bluetooth" "Dispositivo eliminado" -i bluetooth
        fi
        ;;
    
    "info")
        # Mostrar información detallada del Bluetooth
        if bluetoothctl show >/dev/null 2>&1; then
            powered=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
            discoverable=$(bluetoothctl show | grep "Discoverable" | awk '{print $2}')
            pairable=$(bluetoothctl show | grep "Pairable" | awk '{print $2}')
            
            echo "Estado del Bluetooth:"
            echo "Encendido: $powered"
            echo "Descubrible: $discoverable"
            echo "Emparejable: $pairable"
            
            connected_count=$(bluetoothctl devices Connected | wc -l)
            paired_count=$(bluetoothctl devices Paired | wc -l)
            
            echo "Dispositivos conectados: $connected_count"
            echo "Dispositivos emparejados: $paired_count"
        else
            echo "No se encontró controlador Bluetooth"
        fi
        ;;
    
    *)
        echo "Uso: $0 {toggle|scan|connect|disconnect|remove|info} [device_mac]"
        echo ""
        echo "Acciones disponibles:"
        echo "  toggle     - Alternar estado del Bluetooth"
        echo "  scan       - Iniciar escaneo de dispositivos"
        echo "  connect    - Conectar a un dispositivo (requiere MAC)"
        echo "  disconnect - Desconectar un dispositivo (requiere MAC)"
        echo "  remove     - Eliminar un dispositivo (requiere MAC)"
        echo "  info       - Mostrar información del Bluetooth"
        ;;
esac