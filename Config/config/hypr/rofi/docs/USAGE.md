# Guía de Uso - Rofi Hyprland

## 🎮 Comandos Básicos

### Lanzadores de Aplicaciones

```bash
# Lanzadores por tipo (1-7)
~/.config/hypr/rofi/scripts/launchers/launcher_t1
~/.config/hypr/rofi/scripts/launchers/launcher_t2
# ... hasta launcher_t7

# Lanzador básico
rofi -show drun -config ~/.config/hypr/rofi/config.rasi
```

### Utilidades del Sistema

```bash
# Menú de energía
~/.config/hypr/rofi/scripts/utilities/powermenu

# Selector de ventanas
~/.config/hypr/rofi/scripts/utilities/windows

# Explorador de archivos
rofi -show filebrowser -config ~/.config/hypr/rofi/config.rasi
```

### Applets Especializados

```bash
# Aplicaciones favoritas
~/.config/hypr/rofi/scripts/applets/apps.sh

# Control de volumen
~/.config/hypr/rofi/scripts/applets/volume.sh

# Control de brillo
~/.config/hypr/rofi/scripts/applets/brightness.sh

# Estado de batería
~/.config/hypr/rofi/scripts/applets/battery.sh

# Control de MPD
~/.config/hypr/rofi/scripts/applets/mpd.sh

# Capturas de pantalla
~/.config/hypr/rofi/scripts/applets/screenshot.sh
```

## 🎨 Personalización de Temas

### Cambiar Esquema de Colores

1. Navega a `themes/shared/colors.rasi`
2. Cambia la línea de importación:
```css
@import "../colors/nord.rasi"
```

### Esquemas Disponibles
- `adapta.rasi` - Tema Adapta
- `arc.rasi` - Tema Arc
- `black.rasi` - Tema Negro
- `catppuccin.rasi` - Tema Catppuccin
- `cyberpunk.rasi` - Tema Cyberpunk
- `dracula.rasi` - Tema Dracula
- `everforest.rasi` - Tema Everforest
- `gruvbox.rasi` - Tema Gruvbox
- `nord.rasi` - Tema Nord
- `onedark.rasi` - Tema OneDark
- `tokyonight.rasi` - Tema Tokyo Night

### Personalizar Lanzadores

Para cambiar el estilo de un lanzador específico:

1. Abre `themes/launchers/type-X/launcher.sh`
2. Modifica la variable `theme`:
```bash
theme='style-5'  # Cambia el número (1-15)
```

## ⚙️ Configuración Avanzada

### Modificar Keybindings

Edita `config/keybindings.rasi` para personalizar atajos:

```css
/* Ejemplo: Cambiar tecla de cancelar */
kb-cancel: "Escape,Control+c";
```

### Configurar Módulos Específicos

#### DRun (Lanzador de Aplicaciones)
Edita `config/modules/drun.rasi`:
```css
drun-display-format: "{name}";  # Solo nombre
drun-show-actions: true;        # Mostrar acciones
```

#### Window Switcher
Edita `config/modules/window.rasi`:
```css
window-format: "{t}";  # Solo título
window-thumbnail: true; # Mostrar miniaturas
```

## 🔧 Integración con Hyprland

### Configuración en hyprland.conf

```bash
# Lanzador principal
bind = SUPER, SPACE, exec, ~/.config/hypr/rofi/scripts/launchers/launcher_t1

# Powermenu
bind = SUPER, X, exec, ~/.config/hypr/rofi/scripts/utilities/powermenu

# Selector de ventanas
bind = ALT, TAB, exec, rofi -show window -config ~/.config/hypr/rofi/config.rasi

# Explorador de archivos
bind = SUPER, E, exec, rofi -show filebrowser -config ~/.config/hypr/rofi/config.rasi
```

### Variables de Entorno Recomendadas

```bash
# En tu .bashrc o .zshrc
export ROFI_CONFIG="$HOME/.config/hypr/rofi/config.rasi"
```

## 🐛 Solución de Problemas

### Script no ejecuta
```bash
# Verificar permisos
chmod +x ~/.config/hypr/rofi/scripts/launchers/launcher_t1

# Verificar ruta
ls -la ~/.config/hypr/rofi/scripts/launchers/
```

### Tema no se aplica
```bash
# Verificar archivo de tema
cat ~/.config/hypr/rofi/themes/shared/colors.rasi

# Probar con tema específico
rofi -show drun -theme ~/.config/hypr/rofi/themes/launchers/type-1/style-1.rasi
```

### Rutas incorrectas
```bash
# Verificar estructura
tree ~/.config/hypr/rofi/ -L 2
```

## 📚 Recursos Adicionales

- [Documentación oficial de Rofi](https://github.com/davatorium/rofi)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Repositorio original de adi1090x](https://github.com/adi1090x/rofi)

---

Para más ayuda, revisa los archivos de configuración en `config/` o consulta la documentación oficial.
