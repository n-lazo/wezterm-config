# Documentación de Assets y Generadores

Este directorio contiene los assets visuales para WezTerm y los scripts para gestionarlos.

## 📁 Estructura

```
assets/
├── generators/
│   ├── install-deps.ps1       # Instalador de dependencias (Windows)
│   ├── install-deps.sh        # Instalador de dependencias (Linux/macOS)
│   ├── generate-parallax.ps1  # Generador de patrones (Windows)
│   └── generate-parallax.sh   # Generador de patrones (Linux/macOS)
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

### install-deps.ps1 / install-deps.sh

**Propósito**: Instalar las dependencias necesarias (ImageMagick, WezTerm) para el funcionamiento de los generadores.

### generate-parallax.ps1 / generate-parallax.sh

**Propósito**: Verificar el entorno y generar los patrones parallax a partir de los stickers en `sources/`.

**Uso**:
```powershell
.\generate-parallax.ps1
```

## 📦 Git LFS

Todos los assets PNG están bajo control de Git LFS. Si ves archivos de pocos bytes o errores de "Asset not found", ejecuta:
```bash
git lfs pull
```

---

**Última actualización**: Marzo 2026
