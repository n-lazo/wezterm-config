# WezTerm Config - Configuración Profesional

Una configuración moderna y versatil de **WezTerm** con tema visual "Gemini", rutas dinámicas y gestión profesional de assets con **Git LFS**.

## 🎨 Características

- ✅ **Rutas dinámicas** - Funciona en cualquier usuario/máquina
- ✅ **Validación de assets** - Detecta automáticamente assets faltantes
- ✅ **Efecto Parallax** - 3 capas de fondo con scroll parallax
- ✅ **Tema Gemini** - Colores cuidadosamente diseñados
- ✅ **Git LFS** - Gestión eficiente de imágenes PNG
- ✅ **Scripts modulares** - Generador y setup de assets

## 📋 Requerimientos

- **WezTerm** 0.15+ ([descargar](https://wezfurlong.org/wezterm/))
- **Git LFS** ([descargar](https://git-lfs.com/))
- **ImageMagick** (solo para regenerar patrones)
- **PowerShell 7+** (para scripts de setup)

## 🚀 Instalación Rápida

### 1. Clonar el repositorio

```bash
git clone <tu-repo> ~/.wezterm-config
cd ~/.wezterm-config
```

### 2. Setup de assets

```powershell
cd assets/generators
.\setup-assets.ps1
```

Esto copia todos los assets a `~/.wezterm_assets`.

### 3. Copiar configuración

```bash
# Windows
Copy-Item wezterm.lua $env:USERPROFILE\.wezterm.lua

# macOS/Linux
cp wezterm.lua ~/.wezterm.lua
```

### 4. Recarga WezTerm

```
Ctrl+Shift+R  # Reload config
```

## 📁 Estructura del Proyecto

```
wezterm-config/
├── .gitattributes              # Configuración de Git LFS
├── .gitignore                  # Archivos a ignorar
├── README.md                   # Este archivo
├── SETUP.md                    # Guía detallada de instalación
├── wezterm.lua                 # Configuración principal
│
└── assets/
    ├── generators/
    │   ├── setup-assets.ps1    # Script de setup
    │   ├── generate-patterns.ps1 # Generador de patrones
    │   └── README.md           # Documentación técnica
    │
    └── source/
        ├── WallpaperGemini.png         # Wallpaper base
        ├── Astronauta.png              # Sticker
        ├── Luna.png                    # Sticker
        ├── Nave.png                    # Sticker
        ├── Galaxia.png                 # Sticker
        ├── Patron_Espacio_Peque.png    # Patrón generado
        └── Patron_Espacio_Mediano.png  # Patrón generado
```

## 🎯 Configuración Destacada

### Rutas Dinámicas

La configuración detecta automáticamente el home del usuario:

```lua
local function get_home_dir()
    return os.getenv("USERPROFILE") or os.getenv("HOME") or wezterm.home_dir
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
# Setup y regenerar en un solo paso
cd assets/generators
.\setup-assets.ps1 -GeneratePatterns

# O ejecutar el generador directamente
.\generate-patterns.ps1 -AssetDir "$env:USERPROFILE\.wezterm_assets"
```

## 💾 Git LFS

El repositorio usa Git LFS para las imágenes PNG. Esto permite:

- ✅ Sincronización eficiente (no duplica archivos binarios)
- ✅ Versionado de imágenes
- ✅ Mejor rendimiento del repositorio
- ✅ Compatibilidad con CI/CD

### Primer clone con Git LFS

```bash
# Si Git LFS no está instalado en el repo
git lfs install
git clone <tu-repo>
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

Los assets no se copiaron. Ejecuta:
```powershell
.\assets\generators\setup-assets.ps1
```

### Las imágenes no cargan después de clonar

Necesitas Git LFS:
```bash
git lfs install
git lfs pull
```

### ImageMagick no encontrado

Instala desde: https://imagemagick.org/

En Windows, asegúrate de agregar a PATH durante instalación.

### Los patrones parallax no se regeneran

Verifica que ImageMagick esté instalado y en PATH:
```powershell
magick --version
```

## 📚 Documentación Adicional

- [SETUP.md](./SETUP.md) - Guía detallada de instalación paso a paso
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
