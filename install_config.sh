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
       echo "Desactivando su DM predeterminado"
sudo systemctl disable $(systemctl list-unit-files --type=service --state=enabled | grep 'dm\.service' | awk '{print $1}')
echo "Activar SDDM como display manager (DM) predeterminado"
sudo systemctl enable sddm.service
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
for section in "Audio" "Desktop Environment" "Power Management" "Bluetooth" "Security" "Terminal" "Utils" "Fonts" "Sistema" "Otros" "Multimedia" "Web" "File" "Code"; do
  echo "Instalando paquetes de la sección $section..."
  packages=$(jq -r ".System[\"$section\"][]" $requirements_file)
  install_packages pacman $packages
done

echo "----- CAMBIANDO LA SHELL -----"

chsh -s /bin/zsh

echo "----- INSTALAND OHMYZSH -----"
#instalar y configurar ohmyzsh
if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
	echo "No está instalado Oh My Zsh, comenzará la instalación"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "Oh My Zsh ya está instalado"
fi

echo "creando enlace para root de'Oh My Zsh'"
# Instalar oh-my-zsh como root
sudo ln -s "$HOME"/.oh-my-zsh /root/
echo "Enlazado"

# tema pówerlevel10k
echo "INSTALANDO TEMA POWERLEVEL10K"
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
	echo "powerlevel10k no está instalado, comenzará a instalarse"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	echo "Modificando .p10k.zsh"
	
else
	echo "powerlevel10k está instalado"
	echo "Modificando .p10k.zsh"
	
fi

echo "---------------------"
echo "----- HACER ESTE PROCESO EN ROOT -----"

echo "creando enlace para root de'aliases y .zshrc'"
# ROOT
sudo ln -s ~/.zshrc /root/
sudo ln -s ~/.aliases /root/

#Plugins
echo "----- INSTALANDO PLUGINS EN USER -----"
echo "Instalando plugins de ohmyzsh"
# Verificar si los repositorios fzf-tab, zsh-syntax-highlighting y zsh-autosuggestions están clonados
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab" ] &&
	[ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] &&
	[ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
	echo "Los repositorios ya están clonados."
else
	# Clonar los repositorios fzf-tab, zsh-syntax-highlighting y zsh-autosuggestions
	git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi


echo "dependencias para el tema"
if pacman -Q "qt5-graphicaleffects" &>/dev/null &&
	pacman -Q "qt5-svg" &>/dev/null &&
	pacman -Q "qt5-quickcontrols2" &>/dev/null; then
	echo "Dependencias para sddm-theme: Instalados"
else
	sudo pacman -S --noconfirm qt5-graphicaleffects qt5-svg qt5-quickcontrols2
	echo "Dependencias para sddm-theme: Instalados"
fi

if ! pacman -Qq "sddm" >/dev/null; then
	echo "sddm: no está instalado"
	echo "Instalando SDDM"
	sudo pacman -S --noconfirm sddm
fi

# instalando el repo chaotic
echo "----- INSTALANDO REPO CHAOTIC_EUR -----"

# Instalar clave primaria
sudo pacman -Sc --noconfirm
sudo pacman-key --init
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

# Instalar keyring y mirrorlist
if ! pacman -Qq chaotic-keyring &>/dev/null; then
	sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
	sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
	sudo pacman -Sc --noconfirm
fi

# Configurar pacman.conf

if [ -f "/etc/pacman.d/chaotic-mirrorlist" ]; then
	if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then

		# Agregar sección [chaotic-aur]
		echo '[chaotic-aur]' | sudo tee -a /etc/pacman.conf

		# Agregar directiva Include
		echo 'Include = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf

	fi
else
	echo "El archivo /etc/pacman.d/chaotic-mirrorlist no existe."
fi

echo "----- INSTALANDO TIENDA DE ARCH -----"
#isntalando la tienda de arch

if pacman -Qq "pamac-all"; then
	echo "Tienda Aur: Instalado"
	if pacman -Qq "powerpill"; then
		sudo pacman -Sy --noconfirm && sudo powerpill -Su && yay -Su
	else
		yay -S --noconfirm powerpill
		sudo pacman -Sy --noconfirm && sudo powerpill -Su && yay -Su
	fi

else
	echo "Tienda Aur: No Instalado"
	yay -S --noconfirm pamac-all
	yay -S --noconfirm powerpill
	sudo pacman -Sy --noconfirm && sudo powerpill -Su && yay -Su
fi
#Iniciando el servicio de bluetooth
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

echo "INSTALACION COMPLETADA"


