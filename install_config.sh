#!/bin/bash

# Actualiza el sistema
sudo pacman -Syu

# Copia los archivos de configuración
cp -r Config/config/* ~/.config
cp -r Config/Home/ ~/

# Pregunta al usuario si quiere cambiar el DM por SDDM
read -p "¿Quieres cambiar el Display Manager a SDDM? (y/n): " change_dm

# Ejecuta comandos según la elección del usuario
case $change_dm in
    y|Y)
        # Instala SDDM y establece como DM
        sudo pacman -S sddm
        sudo systemctl enable sddm.service --force
        chmod +x sddm-theme/sddm_install.sh
        ./sddm-theme/sddm_install.sh
        ;;
    n|N)
        echo "Manteniendo el Display Manager actual."
        ;;
    *)
        echo "Opción no válida. No se cambiará el Display Manager."
        ;;
esac
# Función para instalar paquetes
install_packages() {
  package_manager=$1
  shift
  for package in "$@"; do
    if pacman -Qi $package &>/dev/null; then
      echo "$package ya está instalado."
    else
      echo "Instalando $package..."
      if ! sudo pacman -S --noconfirm $package; then
        if command -v yay &>/dev/null; then
          echo "Intentando instalar $package con yay..."
          yay -S --noconfirm $package
        elif command -v paru &>/dev/null; then
          echo "Intentando instalar $package con paru..."
          paru -S --noconfirm $package
        else
          echo "No se pudo instalar $package. Yay o Paru no están disponibles."
        fi
      fi
    fi
  done
}

# Leer el archivo requirements.json
requirements_file="requirements.json"

if [[ ! -f $requirements_file ]]; then
  echo "El archivo $requirements_file no existe."
  exit 1
fi

# Instalar dependencias de cada sección
for section in "Audio" "Desktop Environment" "Power Management" "Bluetooth" "Security" "Terminal" "Utils"; do
  echo "Instalando paquetes de la sección $section..."
  packages=$(jq -r ".System[\"$section\"][]" $requirements_file)
  install_packages pacman $packages
done



