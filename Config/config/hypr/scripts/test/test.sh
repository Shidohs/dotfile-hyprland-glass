#!/bin/bash

# Limpiar la pantalla
clear

# Función para mostrar la animación de git
show_git_animation() {
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧")
    local delay=0.1
    while true; do
        for frame in "${frames[@]}"; do
            echo -en "\r$frame"
            sleep $delay
        done
    done
}

# Función para detener la animación de git
stop_git_animation() {
    kill $animation_pid >/dev/null 2>&1
    wait $animation_pid 2>/dev/null
}

# Iniciar la animación de git en segundo plano
show_git_animation &
animation_pid=$!

# Variables para controlar la selección y la barra de progreso
options=("Opción 1" "Opción 2" "Opción 3" "Salir")
selected=0
progress=0

# Función para mostrar el menú
show_menu() {
    clear
    echo "Seleccione una opción:"
    for i in "${!options[@]}"; do
        if [[ $i -eq $selected ]]; then
            echo "-> ${options[$i]}"
        else
            echo "  ${options[$i]}"
        fi
    done
}

# Función para mostrar la barra de progreso
show_progress() {
    echo -n "Progreso: ["
    for ((i = 0; i < $progress; i++)); do
        echo -n "#"
    done
    for ((i = $progress; i < 10; i++)); do
        echo -n " "
    done
    echo "]"
}

# Función para mover la selección hacia arriba
move_up() {
    selected=$((($selected - 1 + ${#options[@]}) % ${#options[@]}))
}

# Función para mover la selección hacia abajo
move_down() {
    selected=$((($selected + 1) % ${#options[@]}))
}

# Bucle principal
while true; do
    show_menu
    show_progress
    read -rsn1 input
    case $input in
    A) move_up ;;
    B) move_down ;;
    "") # Enter key
        if [ $selected -eq $((${#options[@]} - 1)) ]; then
            # Salir si se selecciona "Salir"
            stop_git_animation
            clear
            exit
        else
            # Realizar alguna acción basada en la opción seleccionada
            echo "Ha seleccionado: ${options[$selected]}"
            # Simular una pausa antes de volver al menú
            sleep 1
        fi
        ;;
    esac
done
