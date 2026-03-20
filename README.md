# WezTerm Config - Configuración Profesional

Una configuración moderna y versatil de **WezTerm** con tema visual "Gemini", rutas dinámicas y gestión profesional de assets con **Git LFS**.

## 🎨 Características

- ✅ **Rutas dinámicas** - Funciona en cualquier usuario/máquina
- ✅ **Validación de assets** - Detecta automáticamente assets faltantes
- ✅ **Efecto Parallax** - 3 capas de fondo con scroll parallax
- ✅ **Tema Gemini** - Colores cuidadosamente diseñados
- ✅ **Git LFS** - Gestión eficiente de imágenes PNG
- ✅ **Scripts modulares** - Generador e instalador de dependencias

## 📋 Requerimientos

- **WezTerm** 0.15+ ([descargar](https://wezfurlong.org/wezterm/))
- **Git LFS** ([descargar](https://git-lfs.com/))
- **ImageMagick** (solo para regenerar patrones)
- **PowerShell 5.0+** (Windows) O **Bash 4.0+** (Linux/macOS)

## 🚀 Instalación Rápida

### Para Windows (PowerShell)

```powershell
# 1. Clonar el repositorio directamente al directorio de config de WezTerm
git clone https://github.com/n-lazo/wezterm-config.git $env:USERPROFILE\.config\wezterm

# 2. (Opcional) Instalar dependencias para assets
$env:USERPROFILE\.config\wezterm\assets\generators\install-deps.ps1

# 3. (Opcional) Configurar Shell (Oh My Posh)
$env:USERPROFILE\.config\wezterm\assets\generators\setup-shell.ps1

# 4. Recarga WezTerm (Ctrl+Shift+R)
```

### Para Linux / macOS (Bash)

```bash
# 1. Clonar el repositorio directamente al directorio de config de WezTerm
git clone https://github.com/n-lazo/wezterm-config.git ~/.config/wezterm

# 2. (Opcional) Consultar instalación de dependencias
chmod +x ~/.config/wezterm/assets/generators/*.sh
~/.config/wezterm/assets/generators/install-deps.sh

# 3. Recarga WezTerm
```

### 📍 Sin pasos de copia

El repositorio **es** el directorio de config de WezTerm — no se copian archivos.
WezTerm carga `wezterm.lua` y los assets directamente desde el repo.

```
Ctrl+Shift+R  # Reload config
```

## 📁 Estructura del Proyecto

```
wezterm-config/
├── .gitattributes                 # Configuración de Git LFS
├── .gitignore                     # Archivos a ignorar
├── README.md                      # Este archivo
├── CLAUDE.md                      # Guía para agentes IA
├── wezterm.lua                    # Configuración principal
│
└── assets/
    ├── generators/
    │   ├── install-deps.ps1       # Instalador de dependencias (Windows)
    │   ├── install-deps.sh        # Instalador de dependencias (Linux/macOS)
    │   ├── setup-shell.ps1        # Configura Oh My Posh (Windows)
    │   ├── generate-parallax.ps1  # Generador de patrones (Windows)
    │   ├── generate-parallax.sh   # Generador de patrones (Linux/macOS)
    │   └── README.md              # Documentación técnica de assets
    │
    ├── sources/                   # Stickers para generar patrones
    │   ├── Astronauta.png         # Sticker
    │   ├── Luna.png               # Sticker
    │   ├── Nave.png               # Sticker
    │   └── Galaxia.png            # Sticker
    │
    └── generated/                 # Patrones generados (usados en la config)
        ├── WallpaperGemini.png    # Wallpaper base
        ├── Patron_Espacio_Peque.png    # Patrón generado (fondo lejano)
        └── Patron_Espacio_Mediano.png  # Patrón generado (fondo cercano)
```

## 🎯 Configuración Destacada

### Rutas de Assets Relativas al Repo

Los assets se referencian relativos al directorio de config, sin rutas hardcodeadas:

```lua
local function asset_path(filename)
    return wezterm.config_dir .. "/assets/generated/" .. filename
end
```

### Validación de Assets

Si un asset está faltante, se detecta automáticamente:

```lua
local function validate_asset(filename)
    local path = asset_path(filename)
    local file = io.open(path, "r")
    if file then io.close(file); return true end
    return false
end
```

### Efecto Parallax

3 capas de fondo con diferentes velocidades de parallax:
- **Capa 1** (Wallpaper): `Parallax = 0.01` - Muy estática
- **Capa 2** (Patrón lejano): `Parallax = 0.2` - Movimiento lento
- **Capa 3** (Patrón cercano): `Parallax = 2.0` - Movimiento rápido

## 🔄 Regenerar Patrones Parallax

Si quieres regenerar los patrones con diferentes parámetros:

```powershell
# Windows
cd assets/generators
.\generate-parallax.ps1
```

```bash
# Linux / macOS
cd assets/generators
./generate-parallax.sh
```

Para mayor control, puedes pasar parámetros:
```powershell
.\generate-parallax.ps1 -AssetDir "..\sources" -OutputDir "..\generated"
```

## 💾 Git LFS

El repositorio usa Git LFS para las imágenes PNG. Esto permite:

- ✅ Sincronización eficiente (no duplica archivos binarios)
- ✅ Versionado de imágenes
- ✅ Mejor rendimiento del repositorio
- ✅ Compatibilidad con CI/CD

### Primer clone con Git LFS

```bash
# Si Git LFS no está instalado en el sistema
git lfs install
git clone https://github.com/n-lazo/wezterm-config.git ~/.config/wezterm
```

## 🎨 Personalización

### Cambiar el tema de colores

Edita la sección "ESQUEMA DE COLORES" en `wezterm.lua`:

```lua
config.colors = {
    background = "#0f1124",      -- Color de fondo
    foreground = "#e6e6e6",      -- Color de texto
    -- ... más colores
}
```

### Ajustar el efecto parallax

En las capas de fondo, cambia el valor `Parallax`:
- **Valores < 1**: Movimiento más lento
- **Valores > 1**: Movimiento más rápido
- **0.01**: Casi estático

### Cambiar fuente o tamaño

```lua
config.font = wezterm.font("Tu-Fuente-Aqui")
config.font_size = 14.0
```

## 🐛 Troubleshooting

### "Asset not found" en logs

El repo no fue clonado con Git LFS. Ejecuta:
```bash
git lfs install
git lfs pull
```

### Las imágenes no cargan después de clonar

Necesitas Git LFS:
```bash
git lfs install
git lfs pull
```

### ImageMagick no encontrado

Instala desde: https://imagemagick.org/ o usa el script `install-deps`.

### Los patrones parallax no se regeneran

Verifica que ImageMagick esté instalado y en PATH:
```powershell
magick --version
```

## 📚 Documentación Adicional

- [assets/README.md](./assets/README.md) - Documentación técnica de assets y generadores

## 🤝 Contribuciones

Las mejoras son bienvenidas. Si encuentras bugs o tienes sugerencias:

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/mejora`)
3. Commit cambios (`git commit -am 'Agrega mejora'`)
4. Push a la rama (`git push origin feature/mejora`)
5. Abre un Pull Request

## 📄 Licencia

MIT - Siéntete libre de usar y modificar esta configuración.

---

**Última actualización**: Marzo 2026

¿Preguntas? Abre un issue en el repositorio.
