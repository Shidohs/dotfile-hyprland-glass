#!/bin/bash

# Actualiza el sistema
echo "Actualizando el sistema..."
sudo pacman -Syu --noconfirm
sudo pacman -S rsync

# Copia los archivos de configuración
echo "Copiando archivos de configuración..."
sudo pacman -S rsync
rsync -av Config/config ~/.config
rsync -av Config/Home ~/

# Pregunta al usuario si quiere cambiar el Display Manager a SDDM
read -p "¿Quieres cambiar el Display Manager a SDDM? (y/n): " change_dm

# Ejecuta comandos según la elección del usuario
case $change_dm in
    y|Y)
        echo "Instalando y configurando SDDM..."
        sudo pacman -S --noconfirm sddm

        echo "Desactivando el Display Manager actual..."
        sudo systemctl disable $(systemctl list-unit-files --type=service --state=enabled | grep 'dm\.service' | awk '{print $1}')

        echo "Activando SDDM como Display Manager..."
        sudo systemctl enable sddm.service

        echo "Instalando el tema para SDDM..."
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
  local package_manager=$1
  shift
  for package in "$@"; do
    if pacman -Qi "$package" &>/dev/null; then
      echo "$package ya está instalado."
    else
      echo "Instalando $package..."
      if ! sudo pacman -S --noconfirm "$package"; then
        echo "Falla al instalar $package con pacman. Intentando con yay o paru..."

        if command -v yay &>/dev/null; then
          yay -S --noconfirm "$package"
        elif command -v paru &>/dev/null; then
          paru -S --noconfirm "$package"
        else
          echo "No se pudo instalar $package. Ni yay ni paru están disponibles."
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
for section in "Audio" "Desktop Environment" "Power Management" "Bluetooth" "Security" "Terminal" "Utilities" "Fonts" "System Utilities" "Miscellaneous" "Multimedia" "Web Browsing" "File Management" "Coding"; do
  echo "Instalando paquetes de la sección $section..."
  packages=$(jq -r ".System[\"$section\"][]" $requirements_file)
  install_packages pacman $packages
done

echo "----- CAMBIANDO LA SHELL A ZSH -----"
# Verificar la shell actual antes de cambiar a zsh
current_shell=$(getent passwd "$USER" | cut -d: -f7)

if [[ "$current_shell" != "/bin/zsh" ]]; then
  echo "Cambiando la shell a zsh..."
  chsh -s /bin/zsh
else
  echo "La shell ya está configurada como zsh."
fi

echo "----- INSTALANDO OH-MY-ZSH -----"
# Instalar y configurar Oh My Zsh
if [ ! -d ~/.oh-my-zsh ]; then
  echo "No está instalado Oh My Zsh, comenzará la instalación..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh ya está instalado."
fi

echo "Creando enlace para root de Oh My Zsh..."
# Instalar oh-my-zsh como root
sudo ln -sf "$HOME/.oh-my-zsh" /root/

echo "Instalando el tema Powerlevel10k..."
# Instalar el tema Powerlevel10k
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

echo "Modificando .p10k.zsh..."
# Aquí podrías agregar comandos para modificar .p10k.zsh si es necesario

echo "----- HACER ESTE PROCESO EN ROOT -----"
echo "Creando enlaces para root de .zshrc y .aliases..."
sudo ln -sf ~/.zshrc /root/
sudo ln -sf ~/.aliases /root/

echo "Instalando plugins para Oh My Zsh..."
# Instalar plugins para Oh My Zsh
for plugin in "fzf-tab" "zsh-syntax-highlighting" "zsh-autosuggestions"; do
  if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin" ]; then
    git clone "https://github.com/Aloxaf/$plugin" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin"
  fi
done

echo "Instalando dependencias para SDDM..."
# Instalar dependencias para SDDM
if ! pacman -Qq "qt5-graphicaleffects" "qt5-svg" "qt5-quickcontrols2" >/dev/null; then
  sudo pacman -S --noconfirm qt5-graphicaleffects qt5-svg qt5-quickcontrols2
fi

echo "Instalando y configurando SDDM..."
# Instalar SDDM si no está instalado
if ! pacman -Qq "sddm" >/dev/null; then
  sudo pacman -S --noconfirm sddm
fi

echo "----- INSTALANDO REPO CHAOTIC_EUR -----"
# Instalar repositorio Chaotic AUR
sudo pacman -Sc --noconfirm
sudo pacman-key --init
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

if ! pacman -Qq chaotic-keyring >/dev/null; then
  sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
  sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
  sudo pacman -Sc --noconfirm
fi

# Configurar pacman.conf
if [ -f "/etc/pacman.d/chaotic-mirrorlist" ]; then
  if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf
    echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
  fi
else
  echo "El archivo /etc/pacman.d/chaotic-mirrorlist no existe."
fi

echo "----- INSTALANDO PAMAC -----"
# Instalar Pamac y Powerpill
if pacman -Qq "pamac-all" >/dev/null; then
  echo "Pamac ya está instalado."
else
  yay -S --noconfirm pamac-all
fi

if pacman -Qq "powerpill" >/dev/null; then
  echo "Powerpill ya está instalado."
else
  yay -S --noconfirm powerpill
fi

# Sincronizar y actualizar el sistema
sudo pacman -Sy --noconfirm
sudo powerpill -Su --noconfirm
yay -Su --noconfirm

echo "Iniciando y habilitando el servicio de Bluetooth..."
# Iniciar y habilitar el servicio de Bluetooth
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

echo "Instalación completada."

