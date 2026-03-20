# Soporte Multi-Plataforma

Scripts compatibles con **Windows (PowerShell)** y **Linux/macOS (Bash)**.

---

## Instalación por Plataforma

### Windows
```powershell
git clone https://github.com/n-lazo/wezterm-config.git $env:USERPROFILE\.config\wezterm
```

### Linux / macOS
```bash
git clone https://github.com/n-lazo/wezterm-config.git ~/.config/wezterm
```

WezTerm detecta automáticamente la config en `~/.config/wezterm/wezterm.lua`. No hay archivos que copiar.

---

## Scripts Disponibles

Los scripts solo son necesarios para **regenerar patrones** o **instalar dependencias**.

### Windows
```powershell
cd $env:USERPROFILE\.config\wezterm\assets\generators

.\setup-assets.ps1                      # Verificar WezTerm
.\setup-assets.ps1 -InstallDeps         # Instalar WezTerm con winget
.\setup-assets.ps1 -GeneratePatterns    # Regenerar patrones parallax
```

### Linux / macOS
```bash
cd ~/.config/wezterm/assets/generators
chmod +x *.sh

./setup-assets.sh                       # Verificar WezTerm
./setup-assets.sh --generate-patterns   # Regenerar patrones parallax
```

---

## Flujo de Instalación

```
1. git clone <repo> ~/.config/wezterm
        ↓
2. Reinicia WezTerm (Ctrl+Shift+R)
        ↓
3. ¡Listo!
```

---

## Comparativa de Scripts

| Característica         | PowerShell | Bash |
|---|---|---|
| Verificar WezTerm      | ✅ | ✅ |
| Instalar WezTerm       | ✅ (winget) | ⚠️ (manual) |
| Regenerar patrones     | ✅ | ✅ |
| Output coloreado       | ✅ | ✅ |

---

## Troubleshooting

### Assets no cargan
```bash
git -C ~/.config/wezterm lfs pull
```

### Permisos de ejecución (Linux/macOS)
```bash
chmod +x ~/.config/wezterm/assets/generators/*.sh
```

### ImageMagick no encontrado
**Windows:** `winget install ImageMagick.ImageMagick`
**macOS:** `brew install imagemagick`
**Linux:** `sudo apt-get install imagemagick`

---

## Notas

- Los assets (PNG) viajan con el repo vía Git LFS — no se copian a ningún lado.
- `wezterm.config_dir` apunta siempre a `~/.config/wezterm/`, por lo que los paths funcionan en cualquier máquina.
- Los stickers en `assets/sources/` solo se necesitan si quieres regenerar patrones.

---

**Última actualización:** Marzo 2026
**Soporte:** Windows 10+, Linux, macOS
