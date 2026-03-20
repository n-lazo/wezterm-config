#!/bin/bash

################################################################################
# GENERADOR DE PATRONES PARALLAX PARA WEZTERM
# Genera los patrones a partir de los stickers en assets/sources.
# Uso: ./generate-patterns.sh [ASSET_DIR] [OUTPUT_DIR]
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSET_DIR="${1:-$SCRIPT_DIR/../sources}"
OUTPUT_DIR="${2:-$SCRIPT_DIR/../generated}"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

test_imagemagick() {
    if command -v magick &> /dev/null; then
        echo -e "${GREEN}✓ ImageMagick encontrado${NC}"
        return 0
    else
        echo -e "${RED}✗ ImageMagick no encontrado. Instálalo desde: https://imagemagick.org/${NC}"
        return 1
    fi
}

test_required_stickers() {
    local required=("Astronauta.png" "Luna.png" "Nave.png" "Galaxia.png")
    for sticker in "${required[@]}"; do
        if [ ! -f "$ASSET_DIR/$sticker" ]; then
            echo -e "${RED}✗ Sticker faltante en $ASSET_DIR: $sticker${NC}"
            return 1
        fi
    done
    return 0
}

generate_pattern() {
    local filename="$1"
    local min_size="${2:-100}"
    local max_size="${3:-150}"
    local cols="${4:-3}"
    local rows="${5:-4}"
    
    echo -e "Generando: $filename ($cols x $rows)..."
    
    local output_path="$OUTPUT_DIR/$filename"
    local canvas_width=2000
    local canvas_height=4000
    
    magick -size "${canvas_width}x${canvas_height}" xc:none -type TrueColorAlpha "$output_path"
    
    local cell_w=$((canvas_width / cols))
    local cell_h=$((canvas_height / (rows * 2 + 1) * 2))
    local safety_margin=60
    
    declare -a stickers=("Astronauta.png" "Luna.png" "Nave.png" "Galaxia.png")
    
    for ((r = 0; r < rows; r++)); do
        for ((c = 0; c < cols; c++)); do
            local chosen="${stickers[$((RANDOM % ${#stickers[@]}))]}"
            local sticker_path="$ASSET_DIR/$chosen"
            local final_w=$((RANDOM % (max_size - min_size) + min_size))
            
            local base_x=$((c * cell_w))
            local base_y=$((r * cell_h))
            
            [ $((c % 2)) -ne 0 ] && base_y=$((base_y + cell_h / 2))
            
            local max_x=$((cell_w - final_w - safety_margin))
            local max_y=$((cell_h - final_w - safety_margin))
            [ $max_x -lt 1 ] && max_x=1
            [ $max_y -lt 1 ] && max_y=1
            
            local jitter_x=$((RANDOM % max_x + safety_margin))
            local jitter_y=$((RANDOM % max_y + safety_margin))
            
            magick "$output_path" "$sticker_path[x$final_w]" -geometry "+$((base_x + jitter_x))+$((base_y + jitter_y))" -colorspace sRGB -composite "$output_path"
        done
    done
    
    magick "$output_path" -type TrueColorAlpha -define png:color-type=6 "$output_path"
    echo -e "${GREEN}✓ Guardado en $output_path${NC}"
}

echo -e "\n${MAGENTA}-- Generador de Patrones Parallax --${NC}"

test_imagemagick || exit 1
test_required_stickers || exit 1
mkdir -p "$OUTPUT_DIR"

generate_pattern "Patron_Espacio_Peque.png" 100 150 3 4
generate_pattern "Patron_Espacio_Mediano.png" 200 300 3 3

echo -e "${GREEN}¡Completado!${NC}\n"
