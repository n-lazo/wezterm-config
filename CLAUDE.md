# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a WezTerm terminal emulator configuration repo. The repo is cloned **directly** to `~/.config/wezterm` — it _is_ the config directory. WezTerm loads `wezterm.lua` on startup.

## Key File

- **`wezterm.lua`** — the single config file. All WezTerm settings live here, organized in numbered sections (security, appearance, font, shell, window, scroll, rendering, background, colors).

## Architecture

### Asset System

Assets are PNG images under `assets/generated/` used as parallax background layers. All asset paths are built via `wezterm.config_dir` (no hardcoded user paths):

```lua
local function asset_path(filename)
    return wezterm.config_dir .. "/assets/generated/" .. filename
end
```

### Background Layers (Parallax)

Three optional image layers stack on top of a solid base color (`#0f1124`):
1. `WallpaperGemini.png` — Parallax 0.01 (nearly static)
2. `Patron_Espacio_Peque.png` — Parallax 0.2 (slow scroll)
3. `Patron_Espacio_Mediano.png` — Parallax 2.0 (fast scroll)

### Asset Generators

Scripts in `assets/generators/` regenerate the PNG patterns using ImageMagick:
- **Windows**: `generate-parallax.ps1`, `install-deps.ps1`
- **Linux/macOS**: `generate-parallax.sh`, `install-deps.sh`

Source sticker PNGs live in `assets/sources/`. Generated PNGs are tracked via Git LFS.

## Applying Config Changes

WezTerm hot-reloads on file save. To force reload: `Ctrl+Shift+R`

## Regenerating Patterns

```powershell
# Windows
cd assets/generators
.\generate-parallax.ps1
```

```bash
# Linux/macOS
cd assets/generators
./generate-parallax.sh
```

## Git LFS

All `.png` files are tracked by Git LFS (see `.gitattributes`). After cloning, if images are missing:

```bash
git lfs pull
```
