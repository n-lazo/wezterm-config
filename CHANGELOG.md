# 📝 Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

## [2.0.0] - Marzo 2026 - Multi-Plataforma

### ✨ Nuevas Características

#### Scripts Bash para Linux/macOS
- ✅ **setup-assets.sh** - Versión Bash del setup de assets
- ✅ **generate-patterns.sh** - Versión Bash del generador de patrones
- ✅ Soporte completo para Linux (Ubuntu, Fedora, etc.)
- ✅ Soporte completo para macOS

#### Mejoras en Instalación
- ✅ Copia automática de `wezterm.lua` en ambas plataformas
- ✅ Validación mejorada de rutas
- ✅ Output coloreado en Windows y Linux/macOS
- ✅ Mensajes de error y éxito más claros

#### Documentación
- ✅ **MULTIPLATFORM.md** - Guía completa de soporte multi-plataforma
- ✅ Actualización de README.md con instrucciones para ambas plataformas
- ✅ Tabla de comparativa de características

### 🔄 Cambios

#### setup-assets.ps1 (Windows)
- Ahora copia automáticamente `wezterm.lua` al final
- Actualizado mensaje de resumen para incluir ubicación de config
- Mejor manejo de errores en copia de config

#### setup-assets.sh (Linux/macOS - NUEVO)
- Equivalente completo de PowerShell version
- Copia automática de `wezterm.lua`
- Soporte para argumentos: `--generate-patterns` / `-g`
- Output coloreado compatible con terminal POSIX

#### generate-patterns.ps1 (Windows)
- Sin cambios funcionales
- Mejor documentación de parámetros

#### generate-patterns.sh (Linux/macOS - NUEVO)
- Equivalente completo de PowerShell version
- Algoritmo idéntico de generación de patrones
- Validaciones consistentes

### 📦 Archivos Modificados

```
Modificados:
- README.md                        (actualizado con instrucciones multi-plataforma)
- setup-assets.ps1               (agregada copia de wezterm.lua)

Nuevos:
- setup-assets.sh                (versión Bash)
- generate-patterns.sh           (versión Bash)
- MULTIPLATFORM.md              (guía de soporte multi-plataforma)
```

### 🎯 Características Idénticas

Ambas versiones (PowerShell y Bash) ahora tienen:

| Característica | Estado |
|---|---|
| Copia de patrones generados | ✅ |
| Copia de wallpaper | ✅ |
| Copia de wezterm.lua | ✅ |
| Validación de directorios | ✅ |
| Generación de patrones | ✅ |
| Output coloreado | ✅ |
| Manejo de errores | ✅ |
| Regeneración de patrones | ✅ |

### 🚀 Instalación Unificada

**Antes (solo Windows):**
```powershell
.\setup-assets.ps1
```

**Ahora (Windows y Linux/macOS):**
```powershell
# Windows
.\setup-assets.ps1

# Linux/macOS
./setup-assets.sh
```

### 🐛 Bug Fixes

- ✅ Fixed: setup-assets.ps1 no copiaba wezterm.lua automáticamente
- ✅ Fixed: Falta de soporte para Linux/macOS
- ✅ Fixed: Mensajes de resumen incompletos en PowerShell

### 📊 Compatibilidad

| SO | Soporte | Scripts | Requisitos |
|---|---|---|---|
| Windows 10+ | ✅ | PS1 | PowerShell 5.0+, ImageMagick |
| Ubuntu/Debian | ✅ | SH | Bash 4.0+, ImageMagick |
| Fedora/RHEL | ✅ | SH | Bash 4.0+, ImageMagick |
| macOS | ✅ | SH | Bash 4.0+, ImageMagick |

---

## [1.0.0] - Marzo 2026 - Lanzamiento Inicial

### Características

- ✅ Configuración de WezTerm con tema Gemini
- ✅ Rutas dinámicas para portabilidad
- ✅ Validación automática de assets
- ✅ Efecto Parallax con 3 capas
- ✅ Git LFS para gestión eficiente de PNGs
- ✅ Scripts PowerShell para setup y generación
- ✅ Documentación completa (README, SETUP, assets/README)

### Archivos Iniciales

```
wezterm-config/
├── wezterm.lua
├── README.md
├── SETUP.md
├── .gitattributes
├── .gitignore
└── assets/
    ├── generators/
    │   ├── setup-assets.ps1
    │   ├── generate-patterns.ps1
    │   └── README.md
    ├── sources/
    │   ├── Astronauta.png
    │   ├── Luna.png
    │   ├── Nave.png
    │   └── Galaxia.png
    └── generated/
        ├── WallpaperGemini.png
        ├── Patron_Espacio_Peque.png
        └── Patron_Espacio_Mediano.png
```

---

## Convenciones de Versioning

Este proyecto sigue [Semantic Versioning](https://semver.org/):

- **MAJOR** - Cambios incompatibles (nueva plataforma, arquitectura diferente)
- **MINOR** - Nuevas características compatibles hacia atrás
- **PATCH** - Bug fixes y mejoras menores

---

## Contribuciones Futuras

Mejoras planeadas:

- [ ] Soporte para otros emuladores de terminal (iTerm2, Alacritty)
- [ ] Generador de patrones mejorado con más opciones
- [ ] Temas adicionales (Nebula, Cosmic, etc.)
- [ ] Configuración interactiva de instalación
- [ ] Sincronización automática entre máquinas
- [ ] Tests automatizados para scripts

---

**Última actualización:** Marzo 2026  
**Mantenedor:** n-lazo
