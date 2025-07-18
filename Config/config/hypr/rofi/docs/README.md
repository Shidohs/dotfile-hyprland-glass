# Configuración de Rofi - Hyprland

Esta es una configuración reorganizada y optimizada de Rofi para Hyprland, basada en el trabajo de [Aditya Shakya (adi1090x)](https://github.com/adi1090x).

## 📁 Estructura del Proyecto

```
rofi/
├── config/                    # Configuraciones principales
│   ├── main.rasi             # Configuración principal
│   ├── keybindings.rasi      # Atajos de teclado
│   └── modules/              # Configuraciones modulares
│       ├── drun.rasi         # Configuración del lanzador de aplicaciones
│       ├── window.rasi       # Configuración del selector de ventanas
│       └── filebrowser.rasi  # Configuración del explorador de archivos
├── themes/                    # Todos los temas organizados
│   ├── colors/               # Esquemas de colores (17 temas)
│   ├── launchers/            # Temas de lanzadores (7 tipos)
│   ├── applets/              # Temas de applets (5 tipos)
│   ├── powermenu/            # Temas de powermenu (6 tipos)
│   └── shared/               # Recursos compartidos
├── scripts/                   # Scripts ejecutables organizados
│   ├── launchers/            # Scripts de lanzadores
│   ├── applets/              # Scripts de applets
│   ├── utilities/            # Scripts de utilidades
│   └── wayland/              # Scripts específicos de Wayland
├── assets/                    # Recursos estáticos
│   ├── images/               # Imágenes y fondos
│   ├── fonts/                # Definiciones de fuentes
│   └── icons/                # Iconos personalizados
└── docs/                      # Documentación
    ├── README.md             # Este archivo
    └── USAGE.md              # Guía de uso
```

## 🚀 Características

- **Configuración modular**: Separación clara de responsabilidades
- **Múltiples temas**: 17 esquemas de colores y múltiples estilos
- **Scripts organizados**: Clasificados por funcionalidad
- **Compatibilidad con Hyprland**: Optimizado para Wayland
- **Fácil mantenimiento**: Estructura intuitiva y documentada

## 📋 Componentes Principales

### Lanzadores (Launchers)
- 7 tipos diferentes de lanzadores
- Múltiples estilos por tipo (15 estilos por tipo)
- Soporte para aplicaciones, archivos y ventanas

### Applets
- 9 applets diferentes: apps, battery, brightness, mpd, powermenu, etc.
- 5 tipos de estilos visuales
- Scripts modulares y personalizables

### Temas de Color
- adapta, arc, black, catppuccin, cyberpunk
- dracula, everforest, glass, gruvbox, lovelace
- navy, nord, onedark, paper, solarized
- tokyonight, yousai

## 🔧 Configuración

El archivo principal `config.rasi` importa automáticamente todas las configuraciones modulares. Para personalizar:

1. **Colores**: Edita archivos en `themes/colors/`
2. **Keybindings**: Modifica `config/keybindings.rasi`
3. **Módulos específicos**: Ajusta archivos en `config/modules/`

## 🎯 Uso Rápido

```bash
# Lanzador tipo 1
./scripts/launchers/launcher_t1

# Powermenu
./scripts/utilities/powermenu

# Applet de aplicaciones
./scripts/applets/apps.sh
```

## 🔄 Migración desde Configuración Anterior

Esta reorganización mantiene toda la funcionalidad existente pero con mejor estructura:

- ✅ Todos los scripts funcionan correctamente
- ✅ Rutas actualizadas automáticamente
- ✅ Compatibilidad con Hyprland
- ✅ Configuración modular para fácil mantenimiento

## 📝 Notas

- Configuración optimizada para Hyprland/Wayland
- Rutas corregidas para la nueva estructura
- Scripts de utilidades actualizados
- Documentación completa incluida

---

**Autor Original**: Aditya Shakya (adi1090x)  
**Reorganización**: Optimizada para mejor mantenibilidad y estructura
