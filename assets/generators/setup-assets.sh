#!/bin/bash

################################################################################
# SETUP DE ASSETS PARA WEZTERM
# Verifica el entorno y opcionalmente regenera los patrones parallax.
# Uso: ./setup-assets.sh [--generate-patterns]
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSET_GENERATED_DIR="$SCRIPT_DIR/../generated"
GENERATE_PATTERNS=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m'

while [[ $# -gt 0 ]]; do
    case $1 in
        --generate-patterns|-g) GENERATE_PATTERNS=true; shift ;;
        *) echo -e "${RED}Argumento desconocido: $1${NC}"; exit 1 ;;
    esac
done

echo -e "\n${MAGENTA}-- WezTerm Asset Setup --${NC}"

# 1. Verificar WezTerm
if command -v wezterm &>/dev/null; then
    echo -e "${GREEN}✓ WezTerm detectado${NC}"
else
    echo -e "${YELLOW}⚠ WezTerm no encontrado en el PATH. Instálalo desde wezfurlong.org${NC}"
fi

# 2. Validar estructura
if [ ! -d "$ASSET_GENERATED_DIR" ]; then
    echo -e "${RED}✗ Error: Directorio de assets generados no encontrado.${NC}"
    echo "  Asegúrate de haber descargado los archivos con Git LFS: git lfs pull"
    exit 1
fi

# 3. Regenerar patrones (opcional)
if [ "$GENERATE_PATTERNS" = true ]; then
    gen_script="$SCRIPT_DIR/generate-patterns.sh"
    if [ -f "$gen_script" ]; then
        chmod +x "$gen_script"
        "$gen_script"
    else
        echo -e "${RED}✗ Error: No se encuentra generate-patterns.sh${NC}"
    fi
fi

echo -e "\n${GREEN}✓ ¡Listo! Recarga WezTerm (Ctrl+Shift+R)${NC}\n"
