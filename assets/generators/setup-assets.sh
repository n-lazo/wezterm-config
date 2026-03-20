#!/bin/bash

################################################################################
# SETUP DE WEZTERM - VERSIÓN BASH
#
# Requiere que el repo esté clonado en el directorio de config de WezTerm:
#   git clone <repo> ~/.config/wezterm
#
# - Verifica WezTerm
# - Opcionalmente regenera los patrones parallax con ImageMagick
#
# Uso:
#   ./setup-assets.sh
#   ./setup-assets.sh --generate-patterns
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSET_GENERATED_DIR="$SCRIPT_DIR/../generated"
ASSET_SOURCES_DIR="$SCRIPT_DIR/../sources"

GENERATE_PATTERNS=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
NC='\033[0m'

while [[ $# -gt 0 ]]; do
    case $1 in
        --generate-patterns|-g)
            GENERATE_PATTERNS=true
            shift
            ;;
        *)
            echo -e "${RED}Argumento desconocido: $1${NC}"
            exit 1
            ;;
    esac
done

print_header() {
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║           SETUP DE WEZTERM                                    ║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error()   { echo -e "${RED}✗ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_info()    { echo -e "${CYAN}$1${NC}"; }

check_wezterm() {
    print_info "Verificando WezTerm..."
    if command -v wezterm &>/dev/null; then
        print_success "WezTerm ya está instalado"
    else
        print_warning "WezTerm no encontrado. Instálalo desde: https://wezfurlong.org/wezterm/"
    fi
    echo ""
}

validate_structure() {
    print_info "Validando estructura..."
    if [ ! -d "$ASSET_GENERATED_DIR" ]; then
        print_error "Directorio de patrones generados no encontrado"
        echo "  Ruta: $ASSET_GENERATED_DIR"
        echo "  Asegúrate de haber clonado el repo con Git LFS habilitado."
        exit 1
    fi
    print_success "Directorio de patrones encontrado"
    echo ""
}

regenerate_patterns() {
    if [ "$GENERATE_PATTERNS" = true ]; then
        print_info "Regenerando patrones parallax..."
        local generate_script="$SCRIPT_DIR/generate-patterns.sh"
        if [ -f "$generate_script" ]; then
            chmod +x "$generate_script"
            "$generate_script" "$ASSET_SOURCES_DIR" "$ASSET_GENERATED_DIR"
            if [ $? -ne 0 ]; then
                print_error "Error en la generación de patrones"
                exit 1
            fi
        else
            print_warning "Script de generación no encontrado: $generate_script"
        fi
        echo ""
    fi
}

print_summary() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    print_success "Setup completado exitosamente!"
    echo ""
    echo -e "${YELLOW}Próximos pasos:${NC}"
    echo -e "${GRAY}  1. Recarga WezTerm (Ctrl+Shift+R o reinicia la app)${NC}"
    echo ""
    if [ "$GENERATE_PATTERNS" = false ]; then
        echo -e "${YELLOW}Para regenerar los patrones (si cambias stickers):${NC}"
        echo -e "${GRAY}  ./setup-assets.sh --generate-patterns${NC}"
        echo ""
    fi
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_header
check_wezterm
validate_structure
regenerate_patterns
print_summary
