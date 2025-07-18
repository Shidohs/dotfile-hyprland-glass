# 📁 Organización de Módulos de Waybar

Esta es la estructura organizada de módulos para Waybar, separados por categorías para facilitar el mantenimiento y la personalización.

## 🗂️ Estructura de Directorios

```
modules/
├── system.jsonc                    # Módulos básicos del sistema
├── system/                         # Módulos específicos del sistema
│   ├── clock.json                  # Reloj y fecha
│   ├── network.json                # Estado de red
│   ├── sound.json                  # Control de audio
│   ├── bluetooth.json              # Gestión de Bluetooth
│   └── pacman.json                 # Gestor de paquetes
├── hyprland/                       # Módulos específicos de Hyprland
│   └── workspaces.json             # Espacios de trabajo
├── custom/                         # Módulos personalizados
│   ├── launcher.json               # Lanzador de aplicaciones
│   ├── powermenu.json              # Menú de energía
│   └── notification.json           # Gestión de notificaciones
└── decorations/                    # Elementos decorativos
    ├── spacing.json                # Espaciado
    └── borders.json                # Bordes decorativos
```

## 📋 Categorías de Módulos

### 🔧 **System** - Módulos del Sistema

- **system.jsonc**: Módulos básicos (CPU, memoria, batería, bandeja)
- **clock.json**: Reloj y fecha con zona horaria
- **network.json**: Estado de WiFi y Ethernet
- **sound.json**: Control de volumen y dispositivos de audio
- **bluetooth.json**: Gestión completa de Bluetooth
- **pacman.json**: Actualizaciones de paquetes

### 🖥️ **Hyprland** - Módulos del Compositor

- **workspaces.json**: Gestión de espacios de trabajo

### 🎨 **Custom** - Módulos Personalizados

- **launcher.json**: Lanzador de aplicaciones (Rofi)
- **powermenu.json**: Menú de energía (Wlogout)
- **notification.json**: Gestión de notificaciones (SwayNC)

### 🎭 **Decorations** - Elementos Decorativos

- **spacing.json**: Espaciado entre módulos
- **borders.json**: Bordes y separadores visuales

## 🛠️ Cómo Agregar Nuevos Módulos

### 1. **Crear el archivo del módulo**

```bash
# Para un módulo del sistema
touch modules/system/nuevo_modulo.json

# Para un módulo personalizado
touch modules/custom/nuevo_modulo.json
```

### 2. **Definir la configuración del módulo**

```json
{
  "nombre-del-modulo": {
    "format": "Texto del módulo",
    "interval": 30,
    "on-click": "comando-a-ejecutar"
  }
}
```

### 3. **Incluir en la configuración principal**

Agregar la ruta al archivo `config.jsonc`:

```json
"include": [
  "~/.config/waybar/modules/system/nuevo_modulo.json"
]
```

## 📝 Convenciones de Nomenclatura

- **Archivos**: Usar `kebab-case` (ej: `nuevo-modulo.json`)
- **Módulos**: Usar `kebab-case` para nombres de módulos
- **Comentarios**: Usar comentarios descriptivos en JSONC
- **Iconos**: Usar iconos Unicode consistentes

## 🔍 Módulos Disponibles

### Módulos del Sistema

- `memory` - Uso de memoria RAM
- `cpu` - Uso de CPU
- `temperature` - Temperatura del sistema
- `battery` - Estado de la batería
- `tray` - Bandeja del sistema

### Módulos de Red y Audio

- `network` - Estado de la conexión de red
- `pulseaudio` - Control de volumen
- `bluetooth` - Gestión de dispositivos Bluetooth

### Módulos Personalizados

- `custom/launch` - Lanzador de aplicaciones
- `custom/powermenu` - Menú de energía
- `custom/notification` - Gestión de notificaciones
- `custom/pacman` - Actualizaciones de paquetes

### Módulos de Hyprland

- `hyprland/workspaces` - Espacios de trabajo

## 🎯 Ventajas de esta Organización

✅ **Fácil mantenimiento** - Cada módulo en su archivo
✅ **Modularidad** - Fácil agregar/quitar módulos
✅ **Claridad** - Estructura lógica por categorías
✅ **Escalabilidad** - Fácil expandir sin desorden
✅ **Depuración** - Problemas fáciles de localizar

## 🔧 Personalización

Para personalizar un módulo específico, simplemente edita su archivo correspondiente. Los cambios se aplicarán automáticamente al reiniciar Waybar.
