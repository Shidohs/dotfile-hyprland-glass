#!/bin/bash

# Función para obtener el estado del controlador Bluetooth
get_controller_status() {
    local powered=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
    local discoverable=$(bluetoothctl show | grep "Discoverable" | awk '{print $2}')
    local pairable=$(bluetoothctl show | grep "Pairable" | awk '{print $2}')
    
    echo "$powered|$discoverable|$pairable"
}

# Función para obtener dispositivos conectados
get_connected_devices() {
    bluetoothctl devices Connected | while read -r line; do
        if [[ $line =~ ^Device\ ([0-9A-Fa-f:]+)\ (.+)$ ]]; then
            local mac="${BASH_REMATCH[1]}"
            local name="${BASH_REMATCH[2]}"
            echo "$mac|$name"
        fi
    done
}

# Función para obtener dispositivos emparejados
get_paired_devices() {
    bluetoothctl devices Paired | while read -r line; do
        if [[ $line =~ ^Device\ ([0-9A-Fa-f:]+)\ (.+)$ ]]; then
            local mac="${BASH_REMATCH[1]}"
            local name="${BASH_REMATCH[2]}"
            echo "$mac|$name"
        fi
    done
}

# Función para obtener información del dispositivo
get_device_info() {
    local mac="$1"
    local info=$(bluetoothctl info "$mac" 2>/dev/null)
    local battery=$(echo "$info" | grep "Battery Percentage" | awk '{print $3}' | tr -d '()')
    local rssi=$(echo "$info" | grep "RSSI" | awk '{print $2}')
    echo "$battery|$rssi"
}

# Obtener estado del controlador
controller_status=$(get_controller_status)
powered=$(echo "$controller_status" | cut -d'|' -f1)
discoverable=$(echo "$controller_status" | cut -d'|' -f2)
pairable=$(echo "$controller_status" | cut -d'|' -f3)

# Verificar si hay controlador Bluetooth
if ! bluetoothctl show >/dev/null 2>&1; then
    echo '{"text": "󰂲", "class": "no-controller", "tooltip": "No se encontró controlador Bluetooth"}'
    exit 0
fi

# Si Bluetooth está apagado
if [[ "$powered" != "yes" ]]; then
    echo '{"text": "󰂲", "class": "off", "tooltip": "Bluetooth desactivado"}'
    exit 0
fi

# Obtener dispositivos conectados
connected_devices=()
while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        connected_devices+=("$line")
    fi
done < <(get_connected_devices)

# Obtener dispositivos emparejados
paired_devices=()
while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        paired_devices+=("$line")
    fi
done < <(get_paired_devices)

# Preparar información para el tooltip
tooltip_info=""
if [[ ${#connected_devices[@]} -gt 0 ]]; then
    tooltip_info="Dispositivos conectados:\n"
    for device in "${connected_devices[@]}"; do
        mac=$(echo "$device" | cut -d'|' -f1)
        name=$(echo "$device" | cut -d'|' -f2)
        device_info=$(get_device_info "$mac")
        battery=$(echo "$device_info" | cut -d'|' -f1)
        rssi=$(echo "$device_info" | cut -d'|' -f2)
        
        tooltip_info+="• $name\n"
        if [[ -n "$battery" && "$battery" != "N/A" ]]; then
            tooltip_info+="  Batería: $battery%\n"
        fi
        if [[ -n "$rssi" ]]; then
            tooltip_info+="  Señal: $rssi dBm\n"
        fi
    done
else
    tooltip_info="No hay dispositivos conectados"
fi

if [[ ${#paired_devices[@]} -gt 0 ]]; then
    tooltip_info+="\n\nDispositivos emparejados:\n"
    for device in "${paired_devices[@]}"; do
        name=$(echo "$device" | cut -d'|' -f2)
        tooltip_info+="• $name\n"
    done
fi

# Determinar el icono y clase basado en el estado
if [[ ${#connected_devices[@]} -gt 0 ]]; then
    icon="󰂱"
    class="connected"
    text="${#connected_devices[@]}"
else
    icon="󰂯"
    class="on"
    text=""
fi

# Crear el JSON de salida
json_output=$(cat <<EOF
{
  "text": "$icon$text",
  "class": "$class",
  "tooltip": "$tooltip_info"
}
EOF
)

echo "$json_output"

