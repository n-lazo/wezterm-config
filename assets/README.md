# Documentación de Assets y Generadores

Este directorio contiene los assets visuales para WezTerm y los scripts para gestionarlos.

## 📁 Estructura

```
assets/
├── generators/
│   ├── setup-assets.ps1       # Script de setup e instalación
│   └── generate-patterns.ps1  # Generador de patrones parallax
│
├── sources/                   # Stickers de entrada (para generar patrones)
│   ├── Astronauta.png
│   ├── Luna.png
│   ├── Nave.png
│   └── Galaxia.png
│
└── generated/                 # Patrones generados (lo que se usa en config)
    ├── WallpaperGemini.png    # Wallpaper base
    ├── Patron_Espacio_Peque.png       # Patrón generado
    └── Patron_Espacio_Mediano.png     # Patrón generado
```

## 📝 Descripción de Assets

### Flujo de Assets

```
sources/ (Entrada)                    generated/ (Salida)
├─ Astronauta.png                    ├─ Patron_Espacio_Peque.png
├─ Luna.png              ──────>      ├─ Patron_Espacio_Mediano.png
├─ Nave.png         [Generador]       └─ WallpaperGemini.png (manual)
└─ Galaxia.png
                                      ~/.wezterm_assets/ (Copia final)
```

### Sources (Stickers para generar patrones)

### Sources (Stickers para generar patrones)

Los stickers son elementos visuales que se combinan con el generador para crear patrones únicos.

- **Astronauta.png** (3.75 MB)
  - Figura de astronauta con traje espacial
  - Solo se usa en la generación de patrones

- **Luna.png** (3.59 MB)
  - Elemento lunar
  - Solo se usa en la generación de patrones

- **Nave.png** (2.93 MB)
  - Nave espacial
  - Solo se usa en la generación de patrones

- **Galaxia.png** (4.66 MB)
  - Elemento de galaxia
  - Solo se usa en la generación de patrones

### Generated (Patrones y Wallpaper - Lo que se usa en la config)

- **WallpaperGemini.png** (5.58 MB)
  - Wallpaper base de alta resolución
  - Tema: Gemini con gradientes y elementos espaciales
  - Usado como capa 1 de fondo con opacidad muy baja (0.02)
  - Efecto: Fondo estático y sutil
  - ⚠️ **Importante**: Este es un wallpaper manual, NO se regenera automáticamente

- **Patron_Espacio_Peque.png** (0.34 MB)
  - Grid: 3 columnas × 4 filas
  - Tamaño de stickers: 100-150 px
  - Efecto: Fondo lejano (Parallax = 0.2)
  - ✅ Se regenera automáticamente con generate-patterns.ps1

- **Patron_Espacio_Mediano.png** (0.83 MB)
  - Grid: 3 columnas × 3 filas
  - Tamaño de stickers: 200-300 px
  - Efecto: Fondo cercano (Parallax = 2.0)
  - ✅ Se regenera automáticamente con generate-patterns.ps1

## 🔧 Scripts de Setup

### setup-assets.ps1

**Propósito**: Copiar assets necesarios del repo al directorio de configuración del usuario.

**Uso básico**:
```powershell
.\setup-assets.ps1
```

**Opción: Regenerar patrones**:
```powershell
.\setup-assets.ps1 -GeneratePatterns
```

**Ubicaciones**:
- **Origen (patrones generados)**: `assets/generated/`
- **Origen (stickers para generar)**: `assets/sources/`
- **Destino**: `~/.wezterm_assets/` (Windows) o `~/.wezterm_assets/` (macOS/Linux)

**Características**:
- ✅ Crea automáticamente el directorio destino si no existe
- ✅ Copia SOLO los archivos necesarios para la config:
  - WallpaperGemini.png (wallpaper base)
  - Patron_Espacio_Peque.png (patrón generado)
  - Patron_Espacio_Mediano.png (patrón generado)
- ✅ NO copia stickers (solo necesarios para regenerar)
- ✅ Opcionalmente regenera patrones si usas `-GeneratePatterns`
- ✅ Valida que existan los archivos necesarios

### generate-patterns.ps1

**Propósito**: Generar los patrones parallax a partir de los stickers.

**Uso básico**:
```powershell
.\generate-patterns.ps1
```

**Parámetros**:

```powershell
# Especificar directorio de assets personalizado
.\generate-patterns.ps1 -AssetDir "C:\mi\ruta\assets"

# Especificar directorio de salida diferente
.\generate-patterns.ps1 -AssetDir "C:\input" -OutputDir "C:\output"
```

**Algoritmo de Generación**:

1. **Crear lienzo**: Canvas transparente de 2000×4000 px
2. **Calcular grilla**: 
   - Número de columnas y filas configurable
   - Altura de celda = CanvasHeight / (Rows + 0.5)
3. **Llenar grilla**:
   - Seleccionar sticker aleatorio (sin repeticiones adyacentes)
   - Calcular posición base en la celda
   - Aplicar desfase (stagger) en columnas impares
   - Añadir jitter aleatorio para variedad
   - Compositar sticker en el lienzo con ImageMagick
4. **Optimizar PNG**: Aplicar optimizaciones de color y compresión

**Parámetros Técnicos**:

- **Canvas Size**: 2000×4000 px (fijo)
- **Grid Columns**: 3 (fijo en scripts default)
- **Grid Rows**: Variable por patrón
  - Pequeño: 4 filas
  - Mediano: 3 filas
- **Sticker Sizes**: 100-150 px (pequeño) o 200-300 px (mediano)
- **Safety Margin**: 60 px (espacio mínimo respecto bordes)

**Ejemplo: Generar patrón personalizado**

```powershell
# En PowerShell, usar -AssetDir y -OutputDir si es necesario
# Los patrones se definen en el script (líneas finales):

Generate-OrganicTiledPattern "Patron_Espacio_Peque.png" 100 150 3 4
# Parámetros: Filename, MinSize, MaxSize, Cols, Rows
```

## 📦 Git LFS

Todos los assets PNG están bajo control de Git LFS para:
- ✅ Mantener el repo ligero (usa pointers en lugar de archivos binarios)
- ✅ Mejor versionado de imágenes
- ✅ Evitar duplicación en histórico

**Configuración**: Ver `.gitattributes` en la raíz del repo.

## 🎨 Personalizar Assets

### Opción 1: Reemplazar Stickers

1. Reemplaza los archivos en `assets/source/` con tus propios stickers
2. Asegúrate que sean PNG de alta calidad
3. Regenera los patrones:
   ```powershell
   .\setup-assets.ps1 -GeneratePatterns
   ```

### Opción 2: Cambiar Parámetros de Generación

Edita `generate-patterns.ps1` al final:

```powershell
# Pequeños: 3 columnas, desfasadas
Generate-OrganicTiledPattern "Patron_Espacio_Peque.png" 100 150 3 4
#                             Nombre                MinSz MaxSz Cols Rows

# Medianos: 3 columnas, desfasadas  
Generate-OrganicTiledPattern "Patron_Espacio_Mediano.png" 200 300 3 3
```

### Opción 3: Crear Nuevos Patrones

```powershell
# Agregar al final de generate-patterns.ps1

# Patrón grande
Generate-OrganicTiledPattern "Patron_Espacio_Grande.png" 300 400 3 2

# Y en wezterm.lua, agregar capa:
local layer4 = build_background_layer("Patron_Espacio_Grande.png", {
    opacity = 0.05,
    repeat_x = "Repeat",
    repeat_y = "Repeat",
    width = 2000,
    height = 4000,
    attachment = { Parallax = 4.0 },
})
if layer4 then table.insert(config.background, layer4) end
```

## 🐛 Debugging

### Verificar assets

```powershell
# Windows
Get-ChildItem $env:USERPROFILE\.wezterm_assets | Select Name, Length
```

```bash
# macOS/Linux
ls -lh ~/.wezterm_assets
```

### Ver logs de generación

El script `generate-patterns.ps1` muestra logs detallados:
- ✓ Sticker colocado
- ✗ Errores de composición
- Resumen final

### Validar PNG

```bash
magick identify -verbose assets/source/Patron_Espacio_Peque.png
```

## 📋 Checklist de Mantenimiento

- [ ] Assets en Git LFS están sincronizados: `git lfs ls-files`
- [ ] `.gitattributes` contiene las rutas correctas
- [ ] Stickers de alta calidad (reemplazados si es necesario)
- [ ] Patrones regenerados después de cambiar stickers
- [ ] Documentación actualizada si se agregan nuevos assets

---

**Última actualización**: Marzo 2026

¿Problemas con los assets? Revisa los logs o abre un issue.
