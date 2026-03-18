#!/bin/bash

################################################################################
# GENERADOR DE PATRONES PARALLAX PARA WEZTERM
# Script en Bash para generar patrones usando ImageMagick
# Requiere: bash, ImageMagick (magick), y stickers de entrada
################################################################################

# ============================================================================
# CONFIGURACIÓN Y VARIABLES
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSET_DIR="${1:-.}"
OUTPUT_DIR="${2:-$ASSET_DIR}"

# Colores para output (compatible con bash/sh)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# ============================================================================
# FUNCIONES DE VALIDACIÓN
# ============================================================================

test_imagemagick() {
    if command -v magick &> /dev/null; then
        local version=$(magick --version | head -1)
        echo -e "${GREEN}✓ ImageMagick encontrado: $version${NC}"
        return 0
    else
        echo -e "${RED}✗ ImageMagick no encontrado. Instálalo desde: https://imagemagick.org/${NC}"
        return 1
    fi
}

test_asset_directory() {
    if [ -d "$ASSET_DIR" ]; then
        echo -e "${GREEN}✓ Assets directory: $ASSET_DIR${NC}"
        return 0
    else
        echo -e "${RED}✗ Directorio de assets no encontrado: $ASSET_DIR${NC}"
        return 1
    fi
}

test_required_stickers() {
    local required=("Astronauta.png" "Luna.png" "Nave.png" "Galaxia.png")
    local missing=()
    
    for sticker in "${required[@]}"; do
        if [ ! -f "$ASSET_DIR/$sticker" ]; then
            missing+=("$sticker")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}✗ Stickers faltantes: ${missing[*]}${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✓ Todos los stickers requeridos encontrados${NC}"
    return 0
}

# ============================================================================
# FUNCIONES GENERADORAS
# ============================================================================

generate_organic_tiled_pattern() {
    local filename="$1"
    local min_size="${2:-100}"
    local max_size="${3:-150}"
    local cols="${4:-3}"
    local rows="${5:-4}"
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Generando: $filename${NC}"
    echo -e "${CYAN}Dimensiones: $cols cols × $rows rows (desfasado)${NC}"
    echo -e "${CYAN}Tamaño de stickers: $min_size-$max_size px${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    local output_path="$OUTPUT_DIR/$filename"
    local canvas_width=2000
    local canvas_height=4000
    
    # 1. Crear lienzo transparente
    magick -size "${canvas_width}x${canvas_height}" xc:none -type TrueColorAlpha "$output_path"
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Error creando lienzo${NC}"
        return 1
    fi
    
    # 2. Calcular dimensiones de celda
    local cell_w=$((canvas_width / cols))
    local cell_h=$((canvas_height / (rows + 1) * 2 / 2))
    local safety_margin=60
    
    # 3. Arreglos para stickers disponibles
    declare -a stickers=("Astronauta.png" "Luna.png" "Nave.png" "Galaxia.png")
    
    # 4. Bucle a través de la grilla
    for ((r = 0; r < rows; r++)); do
        for ((c = 0; c < cols; c++)); do
            # Elegir sticker aleatorio (simplificado, no evita adyacentes)
            local chosen="${stickers[$((RANDOM % ${#stickers[@]}))]}"
            local sticker_path="$ASSET_DIR/$chosen"
            
            # Calcular tamaño aleatorio
            local final_w=$((RANDOM % (max_size - min_size) + min_size))
            
            # Calcular posición base
            local base_x=$((c * cell_w))
            local base_y=$((r * cell_h))
            
            # Stagger: columnas impares se desplazan hacia abajo
            if [ $((c % 2)) -ne 0 ]; then
                base_y=$((base_y + cell_h / 2))
            fi
            
            # Jitter para mayor naturalidad
            local max_x=$((cell_w - final_w - safety_margin))
            local max_y=$((cell_h - final_w - safety_margin))
            
            [ $max_x -lt 1 ] && max_x=1
            [ $max_y -lt 1 ] && max_y=1
            
            local jitter_x=$((RANDOM % max_x + safety_margin))
            local jitter_y=$((RANDOM % max_y + safety_margin))
            
            local final_x=$((base_x + jitter_x))
            local final_y=$((base_y + jitter_y))
            
            # Compositar sticker en el lienzo
            magick "$output_path" \
                "$sticker_path[x$final_w]" \
                -geometry "+$final_x+$final_y" \
                -colorspace sRGB \
                -composite "$output_path"
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}  ✓ Celda [$r,$c]: $chosen @ ($final_x, $final_y)${NC}"
            else
                echo -e "${RED}  ✗ Error en celda [$r,$c]${NC}"
                return 1
            fi
        done
    done
    
    # 5. Optimizar PNG
    magick "$output_path" \
        -type TrueColorAlpha \
        -define png:color-type=6 \
        "$output_path"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Error optimizando PNG${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✓ $filename generado exitosamente${NC}"
    return 0
}

# ============================================================================
# EJECUCIÓN PRINCIPAL
# ============================================================================

echo ""
echo -e "${MAGENTA}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║   GENERADOR DE PATRONES PARALLAX PARA WEZTERM         ║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Validaciones
if ! test_imagemagick; then exit 1; fi
if ! test_asset_directory; then exit 1; fi
if ! test_required_stickers; then exit 1; fi

local_success=true

# Generar patrones
if ! generate_organic_tiled_pattern "Patron_Espacio_Peque.png" 100 150 3 4; then 
    local_success=false
fi
if ! generate_organic_tiled_pattern "Patron_Espacio_Mediano.png" 200 300 3 3; then 
    local_success=false
fi

# Resumen final
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ "$local_success" = true ]; then
    echo -e "${GREEN}✓ ¡Generación completada exitosamente!${NC}"
    echo -e "${GREEN}  Los patrones están en: $OUTPUT_DIR${NC}"
else
    echo -e "${RED}✗ La generación tuvo errores${NC}"
    exit 1
fi
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
