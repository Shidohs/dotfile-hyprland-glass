# ⌨️ Atajos de Teclado - Hyprland Glass

Esta es la guía completa de todos los atajos de teclado disponibles en tu configuración de Hyprland Glass.

## 🚀 Aplicaciones Principales

| Atajo | Acción | Descripción |
|-------|--------|-------------|
| `Super + Enter` | Abrir terminal | Abre Kitty (terminal principal) |
| `Super + D` | Launcher de aplicaciones | Abre Rofi para buscar aplicaciones |
| `Super + B` | Navegador web | Abre el navegador predeterminado |
| `Super + E` | Gestor de archivos | Abre Thunar |
| `Super + C` | Editor de código | Abre VSCode/editor configurado |
| `Super + L` | Bloquear pantalla | Activa Hyprlock |

## 🪟 Gestión de Ventanas

| Atajo | Acción | Descripción |
|-------|--------|-------------|
| `Super + Q` | Cerrar ventana | Cierra la ventana activa |
| `Super + V` | Alternar flotante | Cambia entre ventana flotante/tiled |
| `Super + M` | Salir de Hyprland | Cierra la sesión |
| `Super + F` | Pantalla completa | Alterna modo fullscreen |
| `Super + ←/→/↑/↓` | Mover foco | Navega entre ventanas |
| `Super + Shift + ←/→/↑/↓` | Mover ventana | Mueve la ventana activa |

## 🏢 Workspaces

| Atajo | Acción | Descripción |
|-------|--------|-------------|
| `Super + 1-7` | Cambiar workspace | Va al workspace especificado |
| `Super + Shift + 1-7` | Mover ventana a workspace | Mueve ventana al workspace |
| `Super + Tab` | Workspace siguiente | Cambia al siguiente workspace |
| `Super + Shift + Tab` | Workspace anterior | Cambia al workspace anterior |

## 🖼️ Control de Wallpapers

| Atajo | Acción | Descripción |
|-------|--------|-------------|
| `Super + Shift + W` | **Cambiar wallpaper** | Cambia el fondo de pantalla inmediatamente |
| `Super + Ctrl + W` | **Reiniciar daemon** | Reinicia el sistema de wallpapers |
| `Super + Alt + W` | **Estado del sistema** | Muestra información del sistema de wallpapers |

## ⚡ Funcionalidades Avanzadas

| Atajo | Acción | Descripción |
|-------|--------|-------------|
| `Super + Shift + M` | **Auto-detectar monitores** | Detecta y configura monitores automáticamente |
| `Super + Shift + P` | **Perfil de trabajo** | Cambia a configuración optimizada para productividad |
| `Super + Shift + G` | **Perfil gaming** | Cambia a configuración optimizada para juegos |
| `Super + Shift + O` | **Organizar workspaces** | Organiza ventanas automáticamente por tipo |
| `Super + Shift + H` | **Monitoreo de salud** | Ejecuta diagnóstico del sistema |
| `Super + Shift + R` | **Recargar configuración** | Recarga la configuración de Hyprland |

## 📸 Capturas y Multimedia

| Atajo | Acción | Descripción |
|-------|--------|-------------|
| `Print` | Captura completa | Captura toda la pantalla |
| `Shift + Print` | Captura de región | Selecciona área para capturar |
| `Super + Print` | Captura de ventana | Captura solo la ventana activa |
| `Alt + Print` | Captura al portapapeles | Copia captura al clipboard |

## 🔊 Audio y Brillo

| Atajo | Acción | Descripción |
|-------|--------|-------------|
| `XF86AudioRaiseVolume` | Subir volumen | Aumenta volumen +5% |
| `XF86AudioLowerVolume` | Bajar volumen | Disminuye volumen -5% |
| `XF86AudioMute` | Silenciar | Alterna mute del audio |
| `XF86MonBrightnessUp` | Subir brillo | Aumenta brillo +10% |
| `XF86MonBrightnessDown` | Bajar brillo | Disminuye brillo -10% |

## 🎮 Modo Gaming

Cuando actives el **Perfil Gaming** (`Super + Shift + G`):

- ✅ **Animaciones deshabilitadas** para máximo rendimiento
- ✅ **Blur deshabilitado** para reducir carga GPU
- ✅ **Reglas especiales** para juegos (fullscreen automático)
- ✅ **Foco manual** (sin seguir mouse)

## 💼 Modo Trabajo

Cuando actives el **Perfil de Trabajo** (`Super + Shift + P`):

- ✅ **Animaciones suaves** para mejor experiencia visual
- ✅ **Foco sigue al mouse** para productividad
- ✅ **Workspaces organizados** automáticamente
- ✅ **Optimizado para multitarea**

## 🔄 Aplicar Cambios

Si los atajos no funcionan después de modificar la configuración:

```bash
# Recargar configuración
hyprctl reload

# O usar el atajo
Super + Shift + R
```

## 🛠️ Personalización

Para modificar o añadir atajos, edita el archivo:
```bash
~/.config/hypr/config/keybinds.conf
```

## 📋 Atajos Rápidos Más Usados

| Combinación | Acción |
|-------------|--------|
| `Super + Enter` | Terminal |
| `Super + D` | Launcher |
| `Super + Shift + W` | Cambiar wallpaper |
| `Super + Q` | Cerrar ventana |
| `Super + 1-7` | Cambiar workspace |
| `Super + Shift + G` | Modo gaming |
| `Super + Shift + P` | Modo trabajo |

---

💡 **Tip**: Todos los atajos que usan `Super` se refieren a la tecla Windows/Cmd.
