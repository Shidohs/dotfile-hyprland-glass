# 🌟 Hyprland Glass - Wayland Desktop Environment

<div align="center">

![Hyprland Glass](https://repository-images.githubusercontent.com/470730648/c4c69fe5-dc70-42b8-aae1-3a6d303656c0)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=fff)](https://archlinux.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-00D9FF?logo=wayland&logoColor=fff)](https://hyprland.org/)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/Shidohs/dotfile-hyprland-glass/graphs/commit-activity)

_Un entorno de escritorio Wayland moderno con efectos de cristal, animaciones fluidas y productividad optimizada_

[🚀 Instalación Rápida](#-instalación-rápida) • [📖 Documentación](#-documentación-completa) • [🎨 Capturas](#-capturas-de-pantalla) • [🛠️ Personalización](#️-personalización)

</div>

---

## ✨ Características Principales

### 🎨 **Diseño Visual**

- **Efectos de cristal** con blur y transparencias elegantes
- **Animaciones fluidas** optimizadas para rendimiento
- **Tema minimalista** con paleta de colores cohesiva
- **Iconografía moderna** con Nerd Fonts y Material Design

### ⚡ **Rendimiento Optimizado**

- **Configuración Nvidia** optimizada para gaming y productividad
- **Gestión inteligente de recursos** con monitoreo automático
- **Perfiles dinámicos** (Trabajo/Gaming) con cambio automático
- **Idle management** inteligente para ahorro de energía

### 🔧 **Funcionalidades Avanzadas**

- **Sistema de wallpapers inteligente** con cambio automático y soporte para symlinks
- **Auto-detección de monitores** con configuración automática
- **Organizador de workspaces** inteligente
- **Sistema de backup** robusto con rollback automático
- **Monitoreo de salud** del sistema en tiempo real
- **Gestión de perfiles** para diferentes casos de uso

### 🎯 **Productividad**

- **Workspaces organizados** por categorías (Terminal, Código, Web, etc.)
- **Atajos de teclado** intuitivos y personalizables
- **Launcher avanzado** con Rofi y múltiples temas
- **Gestión de ventanas** automática con reglas inteligentes

---

## 🚀 Instalación Rápida

### 📋 Requisitos Previos

- **Sistema Operativo:** Arch Linux (o derivados)
- **Conexión a Internet:** Para descargar dependencias
- **Privilegios de administrador:** Para instalación de paquetes
- **Git:** Para clonar el repositorio

### ⚡ Instalación Automática

```bash
# 1. Clonar el repositorio
git clone https://github.com/Shidohs/dotfile-hyprland-glass.git
cd dotfile-hyprland-glass

# 2. Ejecutar instalación automática
chmod +x install_config.sh
./install_config.sh
```

### 🔄 Post-Instalación

```bash
# 3. Reiniciar para aplicar cambios
sudo reboot

# 4. Iniciar Hyprland (si usas un DM diferente)
Hyprland
```

---

## 📖 Documentación Completa

### 🏗️ Arquitectura del Sistema

```
~/.config/hypr/
├── 📁 config/           # Configuraciones modulares
│   ├── autostart.conf   # Aplicaciones de inicio
│   ├── keybinds.conf    # Atajos de teclado
│   ├── monitors.conf    # Configuración de monitores
│   └── window-rules.conf # Reglas de ventanas
├── 📁 scripts/          # Scripts de automatización
│   ├── system/          # Scripts del sistema
│   └── tools/           # Herramientas de usuario
├── 📁 themes/           # Temas y colores
├── 📁 rofi/            # Configuración de Rofi
├── 📁 profiles/        # Perfiles de uso
└── 📄 hyprland.conf    # Configuración principal
```

### 🎮 Componentes del Sistema

| Componente             | Descripción                  | Configuración          |
| ---------------------- | ---------------------------- | ---------------------- |
| **🪟 Hyprland**        | Compositor Wayland principal | `hyprland.conf`        |
| **📊 Waybar**          | Barra de estado moderna      | Auto-configurada       |
| **🔔 SwayNC**          | Centro de notificaciones     | Tema glass incluido    |
| **🚀 Rofi**            | Launcher de aplicaciones     | 15+ temas disponibles  |
| **🖥️ Kitty/Alacritty** | Terminales optimizadas       | Configuración incluida |
| **🎨 Swaybg**          | Gestor de fondos de pantalla | Cambio automático      |
| **🔒 Hyprlock**        | Bloqueo de pantalla          | Efectos de cristal     |

---

## ⌨️ Atajos de Teclado

### 🚀 Aplicaciones Principales

| Atajo           | Acción                   |
| --------------- | ------------------------ |
| `Super + Enter` | Abrir terminal           |
| `Super + D`     | Launcher de aplicaciones |
| `Super + B`     | Navegador web            |
| `Super + E`     | Gestor de archivos       |
| `Super + C`     | Editor de código         |
| `Super + L`     | Bloquear pantalla        |

### 🪟 Gestión de Ventanas

| Atajo                 | Acción                    |
| --------------------- | ------------------------- |
| `Super + Q`           | Cerrar ventana            |
| `Super + V`           | Alternar flotante         |
| `Super + M`           | Salir de Hyprland         |
| `Super + ←/→/↑/↓`     | Mover foco                |
| `Super + 1-7`         | Cambiar workspace         |
| `Super + Shift + 1-7` | Mover ventana a workspace |

### 🖼️ Control de Wallpapers

| Atajo               | Acción                               |
| ------------------- | ------------------------------------ |
| `Super + Shift + W` | **Cambiar wallpaper inmediatamente** |
| `Super + Ctrl + W`  | **Reiniciar daemon de wallpapers**   |
| `Super + Alt + W`   | **Ver estado del sistema**           |

### ⚡ Funciones Avanzadas

| Atajo               | Acción                  |
| ------------------- | ----------------------- |
| `Super + Shift + M` | Auto-detectar monitores |
| `Super + Shift + P` | Perfil de trabajo       |
| `Super + Shift + G` | Perfil gaming           |
| `Super + Shift + O` | Organizar workspaces    |
| `Super + Shift + H` | Monitoreo de salud      |
| `Super + Shift + R` | Reiniciar Waybar        |

### 📸 Capturas y Multimedia

| Atajo                  | Acción                       |
| ---------------------- | ---------------------------- |
| `Print`                | Captura de pantalla completa |
| `Shift + Print`        | Captura de región            |
| `Super + Print`        | Captura de ventana           |
| `XF86AudioRaiseVolume` | Subir volumen                |
| `XF86MonBrightnessUp`  | Subir brillo                 |

📖 **[Ver guía completa de atajos de teclado](KEYBINDS.md)** - Documentación detallada con ejemplos y tips

---

## 🎨 Capturas de Pantalla

### 🖥️ Escritorio Principal

![Preview Principal](screenshot/hyprland.png)

### 🎮 Modo Gaming

_Animaciones deshabilitadas, máximo rendimiento_

### 💼 Modo Trabajo

_Optimizado para productividad y multitarea_

### 🌙 Bloqueo de Pantalla

_Efectos de cristal con blur dinámico_

---

## 🛠️ Personalización

### 🖼️ Sistema de Wallpapers

```bash
# Cambiar wallpaper inmediatamente
Super + Shift + W

# Control por línea de comandos
~/.config/hypr/scripts/tools/wallpaper-control.sh change
~/.config/hypr/scripts/tools/wallpaper-control.sh status
~/.config/hypr/scripts/tools/wallpaper-control.sh restart

# Diagnóstico si hay problemas
~/.config/hypr/scripts/tools/wallpaper-debug.sh
```

**Características del sistema de wallpapers:**

- ✅ **Cambio automático** cada 30 minutos
- ✅ **Soporte para symlinks** (funciona con `ln -s`)
- ✅ **Integración con pywal** para colores dinámicos
- ✅ **Control por atajos de teclado**
- ✅ **Logging detallado** para debugging
- ✅ **Múltiples formatos** soportados (PNG, JPG, WEBP, etc.)

### 🎨 Cambiar Temas

```bash
# Cambiar tema de Rofi
~/.config/hypr/rofi/scripts/utilities/themes

# Cambiar colores del sistema
nano ~/.config/hypr/themes/colors/default.conf
```

### 🖥️ Configurar Monitores

```bash
# Auto-detectar monitores
Super + Shift + M

# Configuración manual
nano ~/.config/hypr/config/monitors.conf
```

### ⚙️ Perfiles de Usuario

```bash
# Crear perfil personalizado
cp ~/.config/hypr/profiles/work.conf ~/.config/hypr/profiles/mi-perfil.conf

# Activar perfil
~/.config/hypr/scripts/tools/profile-manager.sh mi-perfil
```

---

## 🔧 Resolución de Problemas

### ❌ Problemas Comunes

<details>
<summary><b>🖥️ Monitores no detectados correctamente</b></summary>

```bash
# Verificar monitores conectados
hyprctl monitors

# Regenerar configuración
~/.config/hypr/scripts/tools/monitor-manager.sh

# Configuración manual
nano ~/.config/hypr/config/monitors.conf
```

</details>

<details>
<summary><b>🎮 Rendimiento bajo en juegos</b></summary>

```bash
# Activar perfil gaming
Super + Shift + G

# Verificar configuración Nvidia
nvidia-smi

# Comprobar variables de entorno
env | grep -E "(NVIDIA|WLR)"
```

</details>

<details>
<summary><b>🔔 Notificaciones no funcionan</b></summary>

```bash
# Reiniciar SwayNC
killall swaync && swaync &

# Verificar configuración
swaync-client -t

# Comprobar servicio
systemctl --user status swaync
```

</details>

<details>
<summary><b>🖼️ Wallpapers no cambian automáticamente</b></summary>

```bash
# Verificar estado del daemon
~/.config/hypr/scripts/tools/wallpaper-control.sh status

# Reiniciar daemon de wallpapers
~/.config/hypr/scripts/tools/wallpaper-control.sh restart

# Diagnóstico completo
~/.config/hypr/scripts/tools/wallpaper-debug.sh

# Ver logs detallados
tail -f ~/.config/hypr/logs/aleatory-wall.log

# Verificar directorio de wallpapers
ls -la ~/Wallpapers/
```

</details>

<details>
<summary><b>⌨️ Atajos de teclado no responden</b></summary>

```bash
# Recargar configuración
hyprctl reload

# Verificar configuración de teclado
hyprctl devices

# Comprobar keybinds
nano ~/.config/hypr/config/keybinds.conf
```

</details>

### 🩺 Diagnóstico del Sistema

```bash
# Monitoreo de salud
~/.config/hypr/scripts/system/health-monitor.sh

# Rendimiento del sistema
~/.config/hypr/scripts/system/performance-monitor.sh

# Logs del sistema
journalctl --user -u hyprland -f
```

### 🔄 Backup y Restauración

```bash
# Crear backup completo
~/.config/hypr/scripts/system/complete-backup.sh

# Listar backups disponibles
ls ~/.config-backups/rollback-scripts/

# Restaurar configuración
bash ~/.config-backups/rollback-scripts/rollback-TIMESTAMP.sh
```

---

## 📦 Dependencias del Sistema

El archivo `requirements.json` contiene todas las dependencias organizadas por categorías:

- **🔊 Audio:** PipeWire, PulseAudio, controles de volumen
- **🖥️ Desktop Environment:** Hyprland, Waybar, SwayNC, portales XDG
- **⚡ Power Management:** UPower, gestión de energía
- **📶 Bluetooth:** BlueZ, Blueman
- **🔒 Security:** Gnome Keyring, Polkit
- **💻 Terminal:** Kitty, Alacritty, Sakura
- **🛠️ Utilities:** Rofi, herramientas de captura, gestores de archivos
- **🎨 Fonts:** Nerd Fonts, Material Design Icons
- **🔧 System Utilities:** Herramientas de sistema y diagnóstico

---

## 🤝 Contribución

### 🐛 Reportar Problemas

1. **Verificar** que el problema no esté ya reportado
2. **Incluir** información del sistema (`neofetch`)
3. **Proporcionar** logs relevantes
4. **Describir** pasos para reproducir el problema

### 💡 Sugerir Mejoras

1. **Fork** del repositorio
2. **Crear** rama para la característica
3. **Implementar** cambios con documentación
4. **Enviar** Pull Request con descripción detallada

### 📝 Contribuir a la Documentación

- Mejorar explicaciones existentes
- Añadir ejemplos de uso
- Traducir a otros idiomas
- Crear tutoriales en video

---

## 🎯 Roadmap

### 🔜 Próximas Características

- [ ] **🎨 Tema Glass para SwayNC** - Centro de notificaciones con efectos de cristal
- [ ] **🔋 Gestor de batería avanzado** - Monitoreo y optimización de energía
- [ ] **🔒 Mejoras en bloqueo de pantalla** - Más efectos y personalización
- [ ] **🚀 Scripts de Rofi mejorados** - Más funcionalidades y temas
- [ ] **📱 Soporte para tablets** - Gestos táctiles optimizados
- [ ] **🌐 Configuración remota** - Gestión desde dispositivos móviles

### 🎨 Temas Adicionales

- [ ] **🌙 Modo oscuro completo** - Tema nocturno para todas las aplicaciones
- [ ] **🌈 Temas dinámicos** - Cambio automático según hora del día
- [ ] **🎮 Temas gaming** - Optimizados para diferentes géneros de juegos

---

## 📄 Licencia

Este proyecto está licenciado bajo la **MIT License** - ver el archivo [LICENSE](LICENSE) para más detalles.

---

## 🙏 Agradecimientos

### 👨‍💻 Desarrolladores

- **[@Shidohs](https://github.com/Shidohs)** - Desarrollador principal
- **[@adi1090x](https://github.com/adi1090x/rofi)** - Temas de Rofi
- **[Hyprland Team](https://github.com/hyprwm/Hyprland)** - Compositor Wayland

### 🎨 Inspiración

- **[r/unixporn](https://reddit.com/r/unixporn)** - Comunidad de personalización
- **[Catppuccin](https://github.com/catppuccin)** - Paleta de colores
- **[Material Design](https://material.io/)** - Principios de diseño

### 🛠️ Herramientas

- **[Hyprland](https://hyprland.org/)** - Compositor Wayland
- **[Waybar](https://github.com/Alexays/Waybar)** - Barra de estado
- **[Rofi](https://github.com/davatorium/rofi)** - Launcher de aplicaciones

---

<div align="center">

**⭐ Si este proyecto te ha sido útil, considera darle una estrella ⭐**

**🐛 ¿Encontraste un problema? [Reporta un issue](https://github.com/Shidohs/dotfile-hyprland-glass/issues)**

**💬 ¿Tienes preguntas? [Inicia una discusión](https://github.com/Shidohs/dotfile-hyprland-glass/discussions)**

---

_Hecho con ❤️ para la comunidad Linux_

</div>
