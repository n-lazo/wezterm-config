# 🖥️ Soporte Multi-Plataforma

Este proyecto incluye scripts compatibles con **Windows (PowerShell)** y **Linux/macOS (Bash)**, permitiendo una configuración consistente en diferentes sistemas operativos.

## 📋 Tabla de Contenidos

- [Scripts Disponibles](#scripts-disponibles)
- [Instalación por Plataforma](#instalación-por-plataforma)
- [Comparativa de Scripts](#comparativa-de-scripts)
- [Troubleshooting](#troubleshooting)

---

## 🚀 Scripts Disponibles

### Windows (PowerShell)

```
assets/generators/
├── setup-assets.ps1           # Setup principal (Windows)
└── generate-patterns.ps1      # Generador de patrones (Windows)
```

**Requiere:** PowerShell 5.0+, ImageMagick

**Uso:**
```powershell
# Setup normal
.\setup-assets.ps1

# Con regeneración de patrones
.\setup-assets.ps1 -GeneratePatterns
```

---

### Linux / macOS (Bash)

```
assets/generators/
├── setup-assets.sh            # Setup principal (Linux/macOS)
└── generate-patterns.sh       # Generador de patrones (Linux/macOS)
```

**Requiere:** Bash 4.0+, ImageMagick

**Uso:**
```bash
# Setup normal
./setup-assets.sh

# Con regeneración de patrones
./setup-assets.sh --generate-patterns
```

---

## 📦 Instalación por Plataforma

### Windows (PowerShell)

#### Prerrequisitos
1. **PowerShell 5.0+** (incluido en Windows 10/11)
2. **ImageMagick**
   ```powershell
   # Usando scoop
   scoop install imagemagick
   
   # O descarga desde: https://imagemagick.org/script/download.php
   ```

#### Instalación
```powershell
# 1. Clonar repositorio
git clone https://github.com/n-lazo/wezterm-config.git
cd wezterm-config

# 2. Permitir ejecución de scripts (si es necesario)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. Ejecutar setup
.\assets\generators\setup-assets.ps1
```

**Resultado:**
- Assets copiados a: `C:\Users\<usuario>\.wezterm_assets\`
- Config copiada a: `C:\Users\<usuario>\.wezterm.lua`

---

### Linux

#### Prerrequisitos
1. **Bash 4.0+** (incluido en la mayoría de distribuciones)
2. **ImageMagick**
   ```bash
   # Ubuntu/Debian
   sudo apt-get install imagemagick
   
   # Fedora/RHEL
   sudo dnf install ImageMagick
   
   # macOS
   brew install imagemagick
   ```

#### Instalación
```bash
# 1. Clonar repositorio
git clone https://github.com/n-lazo/wezterm-config.git
cd wezterm-config

# 2. Hacer scripts ejecutables
chmod +x assets/generators/*.sh

# 3. Ejecutar setup
./assets/generators/setup-assets.sh
```

**Resultado:**
- Assets copiados a: `~/.wezterm_assets/`
- Config copiada a: `~/.wezterm.lua`

---

### macOS

#### Prerrequisitos
1. **Bash 4.0+** (incluido en macOS)
2. **ImageMagick**
   ```bash
   brew install imagemagick
   ```

#### Instalación
```bash
# 1. Clonar repositorio
git clone https://github.com/n-lazo/wezterm-config.git
cd wezterm-config

# 2. Hacer scripts ejecutables
chmod +x assets/generators/*.sh

# 3. Ejecutar setup
./assets/generators/setup-assets.sh
```

**Resultado:**
- Assets copiados a: `~/.wezterm_assets/`
- Config copiada a: `~/.wezterm.lua`

---

## 🔄 Comparativa de Scripts

### Características

| Característica | PowerShell | Bash | Status |
|---|---|---|---|
| Setup de assets | ✅ | ✅ | 100% compatible |
| Generación de patrones | ✅ | ✅ | 100% compatible |
| Copia de wezterm.lua | ✅ | ✅ | 100% compatible |
| Validación de archivos | ✅ | ✅ | 100% compatible |
| Regeneración de patrones | ✅ | ✅ | 100% compatible |
| Output coloreado | ✅ | ✅ | 100% compatible |
| Error handling | ✅ | ✅ | 100% compatible |

### Sintaxis de Parámetros

**PowerShell:**
```powershell
.\setup-assets.ps1                    # Setup normal
.\setup-assets.ps1 -GeneratePatterns  # Con regeneración
```

**Bash:**
```bash
./setup-assets.sh                     # Setup normal
./setup-assets.sh --generate-patterns # Con regeneración
```

---

## 📊 Archivos Copiados

Ambos scripts copian exactamente los mismos archivos:

```
~/.wezterm_assets/
├── WallpaperGemini.png
├── Patron_Espacio_Peque.png
└── Patron_Espacio_Mediano.png

~/.wezterm.lua                        (config principal)
```

**Tamaño total:** ~6.75 MB

---

## 🔧 Regenerar Patrones

Si modificas los stickers en `assets/sources/`, puedes regenerar los patrones:

### Windows
```powershell
.\setup-assets.ps1 -GeneratePatterns
```

### Linux / macOS
```bash
./setup-assets.sh --generate-patterns
```

Esto:
1. Lee los stickers de `assets/sources/`
2. Genera nuevos patrones en `assets/generated/`
3. Copia los nuevos patrones a `~/.wezterm_assets/`

---

## 🎯 Flujo de Instalación Unificado

Independientemente de tu plataforma:

```
1. git clone https://github.com/n-lazo/wezterm-config.git
        ↓
2. cd wezterm-config
        ↓
3. [Windows] .\setup-assets.ps1
   [Linux]   ./setup-assets.sh
   [macOS]   ./setup-assets.sh
        ↓
4. Reinicia WezTerm (Ctrl+Shift+R)
        ↓
5. ¡Listo! 🎉
```

---

## ⚙️ Variables de Entorno

Ambos scripts utilizan las siguientes rutas automáticamente:

### Windows
```powershell
$HOME            # C:\Users\<usuario>
$HOME\.wezterm_assets
$HOME\.wezterm.lua
```

### Linux / macOS
```bash
$HOME            # /home/<usuario> o /Users/<usuario>
$HOME/.wezterm_assets
$HOME/.wezterm.lua
```

---

## 🐛 Troubleshooting

### ImageMagick no encontrado

**Windows:**
```powershell
# Verifica que esté en PATH
magick --version

# Si no funciona, reinstala
scoop uninstall imagemagick
scoop install imagemagick
```

**Linux:**
```bash
# Verifica que esté instalado
which magick

# Ubuntu
sudo apt-get install imagemagick

# Fedora
sudo dnf install ImageMagick
```

### Permisos de ejecución (Linux/macOS)

```bash
# Hacer scripts ejecutables
chmod +x assets/generators/*.sh

# Verificar permisos
ls -l assets/generators/*.sh
```

### Script falla en Bash antiguo

```bash
# Verifica versión de Bash
bash --version

# Si es < 4.0, actualiza
# macOS: brew install bash
# Linux: sudo apt-get install --only-upgrade bash
```

### Colores no aparecen en terminal

Los scripts detectan automáticamente el soporte de color. Si no aparecen:

**Linux/macOS:**
```bash
# Asegúrate de que el terminal tenga TERM correcta
echo $TERM  # Debe mostrar: xterm-256color o similar
```

---

## 📝 Notas Importantes

1. **Git LFS**: Los PNGs se descargan on-demand al clonar
2. **Stickers**: No se copian en setup (son solo para generar)
3. **Config Local**: Los archivos en `~/.wezterm_assets/` son locales y no se sincronizan
4. **Regeneración**: Los patrones se pueden regenerar fácilmente si cambias los stickers
5. **Equivalencia**: Ambas versiones (PowerShell y Bash) tienen exactamente las mismas características

---

## 🔗 Enlaces Relacionados

- [README.md](README.md) - Documentación principal
- [SETUP.md](SETUP.md) - Guía de configuración
- [assets/README.md](assets/README.md) - Detalles técnicos de assets

---

**Última actualización:** Marzo 2026  
**Versión:** 2.0 (Multi-plataforma)  
**Soporte:** Windows 10+, Linux, macOS
