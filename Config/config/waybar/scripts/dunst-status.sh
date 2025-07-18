#!/bin/bash

# Variables para el estado anterior
LAST_STATUS=""

# Función para obtener el estado actual
get_status() {
    if dunstctl is-paused | grep -q "true"; then
        echo '{"alt": "paused", "tooltip": "Notifications Paused"}'
    else
        COUNT=$(dunstctl count waiting)
        if [ "$COUNT" -gt 0 ]; then
            echo "{\"alt\": \"notification\", \"tooltip\": \"$COUNT notifications waiting\"}"
        else
            echo '{"alt": "none", "tooltip": "No notifications"}'
        fi
    fi
}

# Función para actualizar el estado solo si hay cambios
update_status() {
    NEW_STATUS=$(get_status)
    if [ "$NEW_STATUS" != "$LAST_STATUS" ]; then
        echo "$NEW_STATUS"
        LAST_STATUS="$NEW_STATUS"
    fi
}

# Imprimir estado inicial
update_status

# Monitorear cambios usando dunstctl subscribe
dunstctl subscribe | while read -r _; do
    update_status
done
