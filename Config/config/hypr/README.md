# 🌟 Hyprland Glass - Configuración Personal

Esta es tu configuración personalizada de Hyprland Glass con todas las mejoras y optimizaciones implementadas.

## 📁 Estructura de Archivos

```
~/.config/hypr/
├── 📄 hyprland.conf          # Configuración principal
├── 📄 hypridle.conf          # Gestión de inactividad
├── 📄 hyprlock.conf          # Bloqueo de pantalla
├── 📄 xdph.conf              # Portal XDG
├── 📁 config/                # Configuraciones modulares
│   ├── autostart.conf        # Aplicaciones de inicio
│   ├── keybinds.conf         # Atajos de teclado
│   ├── monitors.conf         # Configuración de monitores
│   └── window-rules.conf     # Reglas de ventanas
├── 📁 scripts/               # Scripts de automatización
│   ├── system/               # Scripts del sistema
│   └── tools/                # Herramientas de usuario
├── 📁 themes/                # Temas y colores
├── 📁 rofi/                  # Configuración de Rofi
├── 📁 profiles/              # Perfiles de uso
└── 📁 logs/                  # Archivos de log
```

## 🚀 Características Principales

### 🎨 **Sistema de Wallpapers Inteligente**
- **Cambio automático** cada 30 minutos
- **Soporte para symlinks** (tu carpeta `wall` funciona perfectamente)
- **Integración con pywal** para colores dinámicos
- **Control por atajos de teclado**

### ⚡ **Perfiles Dinámicos**
- **Modo Trabajo**: Optimizado para productividad
- **Modo Gaming**: Máximo rendimiento, animaciones deshabilitadas
- **Cambio rápido** con atajos de teclado

### 🖥️ **Gestión de Monitores**
- **Auto-detección** de monitores conectados
- **Configuración automática** de workspaces
- **Soporte multi-monitor** completo

### 🔧 **Herramientas de Mantenimiento**
- **Sistema de backup** automático con rollback
- **Monitoreo de salud** del sistema
- **Logs detallados** para debugging
- **Scripts de diagnóstico**

## ⌨️ Atajos de Teclado Principales

### 🖼️ **Control de Wallpapers**
- `Super + Shift + W` → Cambiar wallpaper inmediatamente
- `Super + Ctrl + W` → Reiniciar daemon de wallpapers
- `Super + Alt + W` → Ver estado del sistema

### ⚡ **Funciones Avanzadas**
- `Super + Shift + P` → Perfil de trabajo
- `Super + Shift + G` → Perfil gaming
- `Super + Shift + M` → Auto-detectar monitores
- `Super + Shift + O` → Organizar workspaces
- `Super + Shift + H` → Monitoreo de salud

### 🚀 **Aplicaciones**
- `Super + Enter` → Terminal
- `Super + D` → Launcher
- `Super + B` → Navegador
- `Super + Q` → Cerrar ventana

📖 **[Ver guía completa de atajos](KEYBINDS.md)**

## 🛠️ Scripts Disponibles

### 📦 **Sistema**
```bash
# Backup completo de configuración
~/.config/hypr/scripts/system/complete-backup.sh

# Limpieza y optimización
~/.config/hypr/scripts/system/cleanup-optimize.sh

# Monitoreo de rendimiento
~/.config/hypr/scripts/system/performance-monitor.sh

# Monitoreo de salud
~/.config/hypr/scripts/system/health-monitor.sh
```

### 🔧 **Herramientas**
```bash
# Control de wallpapers
~/.config/hypr/scripts/tools/wallpaper-control.sh [status|start|stop|change]

# Diagnóstico de wallpapers
~/.config/hypr/scripts/tools/wallpaper-debug.sh

# Gestión de monitores
~/.config/hypr/scripts/tools/monitor-manager.sh

# Gestión de perfiles
~/.config/hypr/scripts/tools/profile-manager.sh [work|gaming]

# Organización de workspaces
~/.config/hypr/scripts/tools/workspace-manager.sh organize
```

## 📊 Estado del Sistema

### ✅ **Funcionando Correctamente**
- ✅ Sistema de wallpapers aleatorios
- ✅ Detección de 14 wallpapers en tu directorio
- ✅ Daemon ejecutándose en segundo plano
- ✅ Integración con pywal y SwayNC
- ✅ Atajos de teclado configurados
- ✅ Perfiles de trabajo y gaming
- ✅ Monitoreo automático de salud

### 🔄 **Servicios Activos**
- AleatoryWall daemon (cambio automático de wallpapers)
- Health monitor (cada 5 minutos)
- Auto-backup system

## 🎯 Uso Diario

### 🌅 **Al Iniciar el Día**
1. `Super + Shift + P` → Activar perfil de trabajo
2. `Super + Shift + O` → Organizar ventanas automáticamente
3. `Super + Shift + W` → Cambiar wallpaper si quieres

### 🎮 **Para Gaming**
1. `Super + Shift + G` → Activar perfil gaming
2. Las animaciones se deshabilitarán automáticamente
3. Máximo rendimiento garantizado

### 🖼️ **Control de Wallpapers**
- **Cambio manual**: `Super + Shift + W`
- **Ver estado**: `Super + Alt + W`
- **Reiniciar si hay problemas**: `Super + Ctrl + W`

## 🔧 Mantenimiento

### 📋 **Comandos Útiles**
```bash
# Ver estado general
~/.config/hypr/scripts/tools/wallpaper-control.sh status

# Diagnóstico completo
~/.config/hypr/scripts/tools/wallpaper-debug.sh

# Backup manual
~/.config/hypr/scripts/system/complete-backup.sh

# Ver logs de wallpapers
tail -f ~/.config/hypr/logs/aleatory-wall.log

# Ver logs de salud del sistema
tail -f ~/.config/hypr/logs/health.log
```

### 🔄 **Si Algo No Funciona**
1. **Recargar configuración**: `Super + Shift + R`
2. **Reiniciar wallpapers**: `Super + Ctrl + W`
3. **Diagnóstico**: `./scripts/tools/wallpaper-debug.sh`
4. **Ver logs**: `./scripts/tools/wallpaper-control.sh logs`

## 📈 Mejoras Implementadas

- ✅ **Script de wallpapers corregido** (error de sintaxis solucionado)
- ✅ **Soporte completo para symlinks** (tu `ln` funciona perfectamente)
- ✅ **Sistema de logging detallado**
- ✅ **Herramientas de diagnóstico**
- ✅ **Control por atajos de teclado**
- ✅ **Perfiles dinámicos** (trabajo/gaming)
- ✅ **Auto-detección de monitores**
- ✅ **Organización automática de workspaces**
- ✅ **Sistema de backup robusto**
- ✅ **Monitoreo de salud automático**

## 🎉 ¡Todo Funcionando!

Tu configuración de Hyprland Glass está completamente optimizada y funcionando. El sistema de wallpapers aleatorios está activo, los atajos de teclado están configurados, y tienes herramientas avanzadas para gestionar tu entorno de escritorio.

---

💡 **Tip**: Si necesitas ayuda con alguna función específica, todos los scripts incluyen opciones `--help` para más información.
