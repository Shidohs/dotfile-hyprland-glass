#!/bin/bash

# Verifica si se ha proporcionado un argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 <archivo.mcpack>"
    exit 1
fi

# Nombre del archivo
FILE=$1

# Verifica si el archivo existe
if [ ! -f "$FILE" ]; then
    echo "El archivo $FILE no existe."
    exit 1
fi

# Nombre del archivo sin extensión
BASENAME=$(basename "$FILE" .mcpack)

# Ruta al directorio de destino (modifica esto según tus necesidades)
DEST_DIR="$HOME/.var/app/io.mrarm.mcpelauncher/data/mcpelauncher/games/com.mojang/resource_packs"

# Renombra el archivo .mcpack a .zip
mv "$FILE" "$BASENAME.zip"

# Crea un directorio temporal para descomprimir
TEMP_DIR=$(mktemp -d)

# Descomprime el archivo zip en el directorio temporal
unzip "$BASENAME.zip" -d "$TEMP_DIR"

# Verifica si el contenido descomprimido está en una carpeta única
FILES_IN_TEMP_DIR=("$TEMP_DIR"/*)
if [ ${#FILES_IN_TEMP_DIR[@]} -eq 1 ] && [ -d "${FILES_IN_TEMP_DIR[0]}" ]; then
    # Hay una sola carpeta en el directorio temporal, úsala directamente
    FINAL_DIR="${FILES_IN_TEMP_DIR[0]}"
else
    # No hay una única carpeta, crea una nueva y mueve todo el contenido allí
    FINAL_DIR="$TEMP_DIR/$BASENAME"
    mkdir "$FINAL_DIR"
    mv "$TEMP_DIR"/* "$FINAL_DIR"
fi

# Verifica si el directorio de destino existe, si no lo crea
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi

# Mueve la carpeta final al directorio de destino
mv "$FINAL_DIR" "$DEST_DIR"

# Limpia el archivo zip y el directorio temporal
rm "$BASENAME.zip"
rm -rf "$TEMP_DIR"

echo "El contenido ha sido movido a $DEST_DIR/$(basename "$FINAL_DIR")."
