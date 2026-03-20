#!/bin/bash

################################################################################
# GENERADOR DE PATRONES PARALLAX PARA WEZTERM
# Verifica el entorno y genera los patrones parallax.
# Uso: ./generate-parallax.sh [ASSET_DIR] [OUTPUT_DIR]
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSET_DIR="${1:-$SCRIPT_DIR/../sources}"
OUTPUT_DIR="${2:-$SCRIPT_DIR/../generated}"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

test_environment() {
    if ! command -v magick &> /dev/null; then
        echo -e "${RED}✗ Error: ImageMagick no encontrado.${NC}"
        echo "  Consulta SETUP.md para instrucciones de instalación."
        return 1
    fi

    local required=("Astronauta.png" "Luna.png" "Nave.png" "Galaxia.png")
    for sticker in "${required[@]}"; do
        if [ ! -f "$ASSET_DIR/$sticker" ]; then
            echo -e "${RED}✗ Error: Falta $sticker en $ASSET_DIR${NC}"
            return 1
        fi
    done

    mkdir -p "$OUTPUT_DIR"
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
            local final_w=$((RANDOM % (max_size - min_size) + min_size))
            
            local base_x=$((c * cell_w))
            local base_y=$((r * cell_h))
            [ $((c % 2)) -ne 0 ] && base_y=$((base_y + cell_h / 2))
            
            local max_x=$((cell_w - final_w - safety_margin))
            local max_y=$((cell_h - final_w - safety_margin))
            [ $max_x -lt 1 ] && max_x=1
            [ $max_y -lt 1 ] && max_y=1
            
            local final_x=$((base_x + RANDOM % max_x + safety_margin))
            local final_y=$((base_y + RANDOM % max_y + safety_margin))
            
            magick "$output_path" "$ASSET_DIR/$chosen[x$final_w]" -geometry "+$final_x+$final_y" -colorspace sRGB -composite "$output_path"
        done
    done
    
    magick "$output_path" -type TrueColorAlpha -define png:color-type=6 "$output_path"
    echo -e "${GREEN}✓ Guardado en $output_path${NC}"
}

echo -e "\n${MAGENTA}-- Generador de Patrones Parallax --${NC}"

if ! test_environment; then exit 1; fi

generate_pattern "Patron_Espacio_Peque.png" 100 150 3 4
generate_pattern "Patron_Espacio_Mediano.png" 200 300 3 3

echo -e "\n${GREEN}✓ ¡Patrones generados exitosamente! Recarga WezTerm (Ctrl+Shift+R)${NC}\n"
