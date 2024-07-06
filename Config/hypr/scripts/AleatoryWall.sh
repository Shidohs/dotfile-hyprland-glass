#!/bin/bash

# Nombre del script
Script_Wall=$(basename "$0")

# Directorio de fondos de pantalla
WALL_DIR="$HOME/Wallpapers"

# Función para matar instancias anteriores del script
kill_previous_instances() {
    local pids=$(pgrep -f "$Script_Wall")

    for pid in $pids; do
        if [ "$pid" != "$$" ]; then
            #echo "Matando la instancia anterior del script con PID: $pid"
            kill -9 "$pid"
        fi
    done
}

# Ejecutar la función para matar instancias anteriores
kill_previous_instances

# Verificar si el directorio de fondos de pantalla existe
if [ ! -d "$WALL_DIR" ]; then
    #echo "El directorio $WALL_DIR no existe."
    exit 1
fi

# Encontrar todos los archivos de imagen en el directorio
mapfile -t WALL < <(find "$WALL_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \))

# Verificar si se encontraron imágenes
if [ ${#WALL[@]} -eq 0 ]; then
    #echo "No se encontraron imágenes en el directorio $WALL_DIR."
    exit 1
fi

#echo "Imágenes encontradas: ${#WALL[@]}"

# Cambiar el fondo de pantalla aleatoriamente
change_wallpaper() {
    # Seleccionar un archivo aleatorio de la lista de fondos de pantalla
    local wallpaper=$(shuf -n 1 -e "${WALL[@]}")

    #echo "Cambiando el fondo de pantalla a: $wallpaper"

    # Establecer el fondo de pantalla usando swaybg
    swaybg -i "$wallpaper" &

    # Verificar si el comando fue exitoso
    if [ $? -ne 0 ]; then
        echo "Error al intentar cambiar el fondo de pantalla a $wallpaper"
    else
        echo "Fondo de pantalla cambiado a $wallpaper"
    fi
}

# Función para ejecutar el script en segundo plano
run_in_background() {
    #echo "Ejecutando en segundo plano..."

    # Llamar a la función para cambiar el fondo de pantalla inicialmente y luego cada 30 minutos
    change_wallpaper
    while true; do
        sleep 1800
        change_wallpaper
    done
}

# Ejecutar el script en segundo plano
run_in_background &
disown
