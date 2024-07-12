#!/bin/bash
# Version 1.0
#Autor: Shidohs
#github: https://github.com/Shidohs

# Archivo JSON donde se guardarán los datos
pacman_json="$HOME/.config/waybar/scripts/system/pacman/pacman.json"

# Obtener el número de paquetes actualizables y el número total de paquetes instalados
update=$(pacman -Qu | wc -l)
package=$(pacman -Qq | wc -l)

# Leer el contenido del archivo JSON si existe
function pacman_check() {
    if [ -f "$pacman_json" ]; then
        old_package=$(jq -r '.packages' "$pacman_json" 2>/dev/null)
        old_update=$(jq -r '.updates' "$pacman_json" 2>/dev/null)

        # Verificar si el archivo JSON existe y si hay diferencias entre los valores antiguos y nuevos
        if [ -n "$old_package" ] && [ -n "$old_update" ]; then
            if [ "$old_package" -ne "$package" ] || [ "$old_update" -ne "$update" ]; then
                echo "{\"packages\": $package, \"updates\": $update}" >"$pacman_json"
            fi
        fi
    else
        # Si el archivo no existe, crea el archivo con las variables predeterminadas
        echo '{"packages": 0, "updates": 0}' >"$pacman_json"
    fi
}

pacman_check
