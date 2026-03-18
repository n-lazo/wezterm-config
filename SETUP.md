# Guía de Instalación Detallada

Esta guía te ayudará a configurar WezTerm con Git LFS en diferentes sistemas operativos.

## Tabla de Contenidos

1. [Pre-requisitos](#pre-requisitos)
2. [Instalación en Windows](#instalación-en-windows)
3. [Instalación en macOS/Linux](#instalación-en-macoslinux)
4. [Verificación](#verificación)
5. [Troubleshooting](#troubleshooting)

---

## Pre-requisitos

Antes de empezar, necesitas instalar:

### 1. WezTerm

**Windows**: [Descarga el installer](https://wezfurlong.org/wezterm/install/windows.html)

**macOS**: 
```bash
brew install wezterm
```

**Linux** (Ubuntu/Debian):
```bash
sudo apt-get install wezterm
```

Verifica la instalación:
```bash
wezterm --version
```

### 2. Git LFS

**Windows**: [Descargar el installer](https://github.com/git-lfs/git-lfs/releases)

**macOS**:
```bash
brew install git-lfs
```

**Linux**:
```bash
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
```

Después de instalar, ejecuta:
```bash
git lfs install
```

Verifica:
```bash
git lfs version
```

### 3. ImageMagick (Opcional, para regenerar patrones)

**Windows**: [Descarga el installer](https://imagemagick.org/script/download.php#windows)
- ✅ Marca "Install ImageMagick object library" durante setup

**macOS**:
```bash
brew install imagemagick
```

**Linux**:
```bash
sudo apt-get install imagemagick
```

Verifica:
```bash
magick --version
```

---

## Instalación en Windows

### Paso 1: Clonar el repositorio

```powershell
# En PowerShell
git clone https://github.com/tu-usuario/wezterm-config.git
cd wezterm-config
```

### Paso 2: Setup de Assets

```powershell
# Navega al directorio de generators
cd assets/generators

# Ejecuta el script de setup
.\setup-assets.ps1
```

Si obtienes error de permisos, ejecuta primero:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Paso 3: Copiar configuración

```powershell
Copy-Item wezterm.lua $env:USERPROFILE\.wezterm.lua -Force
```

Verifica que el archivo esté en lugar correcto:
```powershell
Test-Path $env:USERPROFILE\.wezterm.lua
```

### Paso 4: Recarga WezTerm

Abre WezTerm y presiona:
```
Ctrl + Shift + R
```

O reinicia la aplicación completamente.

### Paso 5 (Opcional): Regenerar patrones

Si tienes ImageMagick instalado y quieres regenerar los patrones:

```powershell
cd assets/generators
.\setup-assets.ps1 -GeneratePatterns
```

---

## Instalación en macOS/Linux

### Paso 1: Clonar el repositorio

```bash
git clone https://github.com/tu-usuario/wezterm-config.git
cd wezterm-config
```

### Paso 2: Setup de Assets

```bash
chmod +x assets/generators/*.ps1
pwsh assets/generators/setup-assets.ps1
```

Si no tienes PowerShell:
```bash
# Copia manualmente
mkdir -p ~/.wezterm_assets
cp assets/source/* ~/.wezterm_assets/
```

### Paso 3: Copiar configuración

```bash
cp wezterm.lua ~/.wezterm.lua
```

### Paso 4: Recarga WezTerm

Presiona en WezTerm:
```
Ctrl + Shift + R
```

---

## Verificación

### Verificar que todo está instalado

```powershell
# Windows PowerShell
Write-Host "WezTerm:" $(wezterm --version)
Write-Host "Git LFS:" $(git lfs version)
Write-Host "Assets:" $(Test-Path $env:USERPROFILE\.wezterm_assets)
Write-Host "Config:" $(Test-Path $env:USERPROFILE\.wezterm.lua)
```

```bash
# macOS/Linux
echo "WezTerm:" $(wezterm --version)
echo "Git LFS:" $(git lfs version)
echo "Assets:" $(ls ~/.wezterm_assets 2>/dev/null && echo "OK" || echo "MISSING")
echo "Config:" $(test -f ~/.wezterm.lua && echo "OK" || echo "MISSING")
```

### Verificar logs de WezTerm

Si hay problemas, revisa los logs:

```powershell
# Windows
Get-Content "$env:APPDATA\wezterm\log.txt" -Tail 50
```

```bash
# macOS/Linux
tail -50 ~/.config/wezterm/log.txt
```

---

## Troubleshooting

### Problema: Assets no se copian

**Solución 1**: Verifica permisos
```powershell
icacls "$env:USERPROFILE\.wezterm_assets" /grant:r "$env:USERNAME:(F)"
```

**Solución 2**: Copia manual
```powershell
Copy-Item "assets/source/*" -Destination "$env:USERPROFILE\.wezterm_assets" -Force -Recurse
```

### Problema: Git LFS no sincroniza

```bash
# Asegúrate de que Git LFS está instalado
git lfs install

# Descarga manualmente los archivos LFS
git lfs pull
```

### Problema: WezTerm no recarga la configuración

```bash
# Cierra completamente WezTerm
# Presiona Ctrl+C en la terminal o cierra la ventana

# Elimina caché
rm -rf ~/.cache/wezterm  # Linux
rm -rf ~/Library/Caches/com.github.wez.wezterm  # macOS
```

### Problema: Los patrones no se generan

Verifica ImageMagick:
```bash
magick --version
```

Si no está instalado, hazlo:

**Windows**: Ejecuta el installer desde https://imagemagick.org/

**macOS**:
```bash
brew install imagemagick
```

**Linux**:
```bash
sudo apt-get install imagemagick
```

### Problema: El cursor no parpadea

Abre `wezterm.lua` y verifica:
```lua
config.default_cursor_style = "BlinkingBar"
```

Si no parpadea aún, recarga: `Ctrl+Shift+R`

### Problema: Los colores no se ven como esperado

1. Verifica que el terminal soporta 24-bit true color
2. Prueba en una terminal diferente
3. Revisa tu variable `TERM`:
   ```bash
   echo $TERM
   ```
   Debería ser `wezterm` o `xterm-256color`

---

## Configuración Avanzada

### Personalizar locaciones de assets

Edita `wezterm.lua` y modifica:

```lua
local function asset_path(filename)
    local home = get_home_dir()
    return home .. "\\.wezterm_assets\\" .. filename  -- Cambiar esta ruta
end
```

### Usar configuración local sin versionar

Crea `wezterm.local.lua`:

```lua
-- wezterm.local.lua - NO se versionará en Git
local config = require("wezterm").config_builder()

-- Overrides locales
config.font_size = 14.0

return config
```

Y carga en `wezterm.lua`:
```lua
local ok, local_config = pcall(require, "wezterm.local")
if ok then
    -- Merge con config principal
end
```

---

¿Problemas? Abre un issue en el repositorio o revisa los logs de WezTerm.
