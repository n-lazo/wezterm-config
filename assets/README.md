# Documentación de Assets y Generadores

Este directorio contiene los assets visuales para WezTerm y los scripts para gestionarlos.

## 📁 Estructura

```
assets/
├── generators/
│   ├── setup-assets.ps1       # Script de mantenimiento y validación
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
```

Los assets se cargan directamente desde `assets/generated/` usando `wezterm.config_dir` en la configuración.

## 🔧 Scripts de Gestión

### setup-assets.ps1 / setup-assets.sh

**Propósito**: Verificar que el entorno sea correcto (WezTerm instalado, assets descargados vía Git LFS) y opcionalmente regenerar patrones.

**Uso**:
```powershell
.\setup-assets.ps1 -GeneratePatterns
```

### generate-patterns.ps1 / generate-patterns.sh

**Propósito**: Generar los patrones parallax a partir de los stickers en `sources/`.

**Uso**:
```powershell
.\generate-patterns.ps1
```

**Parámetros**:
- `-AssetDir`: Directorio de stickers (default: `..\sources`)
- `-OutputDir`: Directorio de salida (default: `..\generated`)

## 📦 Git LFS

Todos los assets PNG están bajo control de Git LFS. Si ves archivos de pocos bytes o errores de "Asset not found", ejecuta:
```bash
git lfs pull
```

---

**Última actualización**: Marzo 2026
