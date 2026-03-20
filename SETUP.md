# Guía de Instalación

## Pre-requisitos

### 1. WezTerm

**Windows:**
```powershell
winget install wez.wezterm
```

**macOS:**
```bash
brew install wezterm
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install wezterm
```

### 2. Git LFS

**Windows:**
```powershell
winget install GitHub.GitLFS
git lfs install
```

**macOS:**
```bash
brew install git-lfs
git lfs install
```

**Linux:**
```bash
sudo apt-get install git-lfs
git lfs install
```

### 3. ImageMagick (opcional, solo para regenerar patrones)

**Windows:** `winget install ImageMagick.ImageMagick`
**macOS:** `brew install imagemagick`
**Linux:** `sudo apt-get install imagemagick`

---

## Instalación

Clona el repositorio directamente al directorio de config de WezTerm — no hay pasos adicionales.

### Windows
```powershell
git clone https://github.com/n-lazo/wezterm-config.git $env:USERPROFILE\.config\wezterm
```

### macOS / Linux
```bash
git clone https://github.com/n-lazo/wezterm-config.git ~/.config/wezterm
```

Recarga WezTerm (`Ctrl+Shift+R`) y listo.

---

## Verificación

```powershell
# Windows
wezterm --version
Test-Path $env:USERPROFILE\.config\wezterm\wezterm.lua
Test-Path $env:USERPROFILE\.config\wezterm\assets\generated\WallpaperGemini.png
```

```bash
# macOS / Linux
wezterm --version
ls ~/.config/wezterm/wezterm.lua
ls ~/.config/wezterm/assets/generated/
```

---

## Troubleshooting

### Assets no cargan (error en logs de WezTerm)

Los PNGs no se descargaron con Git LFS:
```bash
git -C ~/.config/wezterm lfs pull
```

### WezTerm no detecta la config

Verifica que no exista una config en ubicaciones con mayor prioridad:
```bash
# Si existe alguno de estos, WezTerm los usará primero:
~/.wezterm.lua
$APPDATA/wezterm/wezterm.lua   # Windows
```

### Permisos en scripts (Linux/macOS)

```bash
chmod +x ~/.config/wezterm/assets/generators/*.sh
```

### Los patrones no se generan

Verifica ImageMagick:
```bash
magick --version
```

---

## Regenerar Patrones Parallax

Si modificas los stickers en `assets/sources/`:

```powershell
# Windows
cd $env:USERPROFILE\.config\wezterm\assets\generators
.\setup-assets.ps1 -GeneratePatterns
```

```bash
# macOS / Linux
cd ~/.config/wezterm/assets/generators
./setup-assets.sh --generate-patterns
```

---

¿Problemas? Abre un issue en el repositorio.
