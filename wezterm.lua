local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ============================================================================
-- UTILITARIOS Y CONFIGURACIÓN DE PATHS
-- ============================================================================

--- Obtiene la ruta del home del usuario de forma dinámica
local function get_home_dir()
	return os.getenv("USERPROFILE") or os.getenv("HOME") or wezterm.home_dir
end

--- Construye una ruta a los assets de wezterm
--- @param filename string Nombre del archivo de asset
--- @return string Ruta completa al asset
local function asset_path(filename)
	local home = get_home_dir()
	return home .. "\\.wezterm_assets\\" .. filename
end

--- Valida que un archivo de asset exista
--- @param filename string Nombre del archivo de asset
--- @return boolean true si existe, false en caso contrario
local function validate_asset(filename)
	local path = asset_path(filename)
	local file = io.open(path, "r")
	if file then
		io.close(file)
		return true
	end
	return false
end

--- Log de errores para debugging
local function log_missing_asset(filename)
	local path = asset_path(filename)
	wezterm.log_error("ASSET NOT FOUND: " .. path)
end

--- Construye un background layer con validación
--- @param filename string Nombre del archivo PNG
--- @param config table Configuración del layer (opacity, parallax, etc.)
--- @return table|nil Layer config o nil si no existe el asset
local function build_background_layer(filename, layer_config)
	if not validate_asset(filename) then
		log_missing_asset(filename)
		return nil
	end

	local layer = layer_config or {}
	layer.source = { File = asset_path(filename) }
	return layer
end

-- ============================================================================
-- 1. SEGURIDAD
-- ============================================================================
config:set_strict_mode(true)

-- ============================================================================
-- 2. APARIENCIA Y FUENTE
-- ============================================================================
config.font = wezterm.font("CaskaydiaMono Nerd Font")
config.font_size = 13.0
config.window_padding = { left = 5, right = 5, top = 5, bottom = 5 }
config.default_cursor_style = "BlinkingBar"
config.window_decorations = "RESIZE"

-- ============================================================================
-- 3. SHELL Y DIRECTORIO
-- ============================================================================
config.default_prog = { "pwsh.exe", "-NoLogo" }
config.default_cwd = get_home_dir()

-- ============================================================================
-- 4. SCROLL Y COMPORTAMIENTO
-- ============================================================================
config.scrollback_lines = 10000
config.enable_scroll_bar = true
config.alternate_buffer_wheel_scroll_speed = 1
config.hide_mouse_cursor_when_typing = true

-- ============================================================================
-- 5. RENDIMIENTO Y APARIENCIA AVANZADA
-- ============================================================================
config.front_end = "WebGpu"

-- ============================================================================
-- 6. CAPAS DE FONDO CON EFECTO PARALLAX Y VALIDACIÓN
-- ============================================================================
config.background = {}

-- CAPA 1: Wallpaper Gemini (Fondo base casi estático)
local layer1 = build_background_layer("WallpaperGemini.png", {
	opacity = 0.02,
	attachment = { Parallax = 0.01 },
	width = "100%",
	height = "100%",
})
if layer1 then table.insert(config.background, layer1) end

-- CAPA 2: Patrón PEQUEÑO (Fondo lejano)
local layer2 = build_background_layer("Patron_Espacio_Peque.png", {
	opacity = 0.03,
	repeat_x = "Repeat",
	repeat_y = "Repeat",
	width = 2000,
	height = 4000,
	attachment = { Parallax = 0.2 },
})
if layer2 then table.insert(config.background, layer2) end

-- CAPA 3: Patrón MEDIANO (Fondo cercano)
local layer3 = build_background_layer("Patron_Espacio_Mediano.png", {
	opacity = 0.04,
	repeat_x = "Repeat",
	repeat_y = "Repeat",
	width = 2000,
	height = 4000,
	attachment = { Parallax = 2.0 },
})
if layer3 then table.insert(config.background, layer3) end

-- Log si faltan assets
if #config.background == 0 then
	wezterm.log_error("WARNING: No background layers loaded! Check asset paths.")
end

-- ============================================================================
-- 7. ESQUEMA DE COLORES (Tema Gemini)
-- ============================================================================
config.colors = {
	background = "#0f1124",
	foreground = "#e6e6e6",

	cursor_bg = "#80ffef",
	cursor_border = "#80ffef",
	cursor_fg = "#0f1124",

	selection_bg = "#2e3366",
	selection_fg = "#e6e6e6",

	scrollbar_thumb = "#333666",
	split = "#1d1f3d",

	ansi = {
		"#1d1f3d", -- black
		"#ff4f77", -- red
		"#a4f781", -- green
		"#ffb02e", -- yellow
		"#4786ff", -- blue
		"#b875ff", -- magenta
		"#80ffef", -- cyan
		"#ffffff", -- white
	},

	brights = {
		"#333666", -- bright_black
		"#ff7b9f", -- bright_red
		"#c1ff9f", -- bright_green
		"#ffd27a", -- bright_yellow
		"#77acff", -- bright_blue
		"#d19fff", -- bright_magenta
		"#a4fff8", -- bright_cyan
		"#ffffff", -- bright_white
	},
}

return config
