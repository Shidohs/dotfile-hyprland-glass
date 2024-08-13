!#/bin/bash

sddm_theme_dir="sddm-theme/themes/"
new_theme="sugar-candy"
if [ -d "/usr/share/sddm/themes" ]; then
	echo "Cargando tema"
	if [ -d "$sddm_theme_dir" ]; then
		sddm_theme_dest="/usr/share/sddm/themes/"
		if [ ! -d "$sddm_theme_dest" ]; then
			sudo mkdir -p "$sddm_theme_dest"
		fi
		sudo rsync -av "$sddm_theme_dir" "$sddm_theme_dest"

		# Leer el archivo /etc/sddm.conf
		if grep -q '^Current=' /etc/sddm.conf; then
			# Reemplazar el valor de Current= con el nuevo tema
			sudo sed -i "s/^Current=.*/Current=$new_theme/" /etc/sddm.conf
		else
			# Si no hay una línea Current=, agregar una nueva
			sudo tee -a /etc/sddm.conf >/dev/null <<EOF
[Theme]
Current=$new_theme
EOF
		fi
	else
		echo "El directorio $sddm_theme_dir no existe"
	fi
else
	echo "El directorio /usr/share/sddm/themes no existe"
fi

echo "SDDM configurado"
