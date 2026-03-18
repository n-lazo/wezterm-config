#!/bin/bash

################################################################################
# SETUP DE ASSETS PARA WEZTERM - VERSIÓN BASH
# 
# Script de setup para WezTerm - copia assets necesarios
# - Copia SOLO los patrones generados y wallpaper (lo que usa la config)
# - NO copia stickers (solo se usan para generar patrones)
# - Opcionalmente regenera los patrones si deseas cambiar stickers
# - Copia wezterm.lua a ~/.wezterm.lua
#
# Uso:
#   ./setup-assets.sh
#   ./setup-assets.sh --generate-patterns
################################################################################

# ============================================================================
# CONFIGURACIÓN Y VARIABLES
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSET_GENERATED_DIR="$SCRIPT_DIR/../generated"
ASSET_SOURCES_DIR="$SCRIPT_DIR/../sources"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
WEZTERM_CONFIG="$REPO_ROOT/wezterm.lua"
ASSET_TARGET_DIR="$HOME/.wezterm_assets"
WEZTERM_TARGET="$HOME/.wezterm.lua"

GENERATE_PATTERNS=false

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Procesar argumentos
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

# ============================================================================
# FUNCIONES AUXILIARES
# ============================================================================

print_header() {
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║           SETUP DE ASSETS PARA WEZTERM                        ║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${CYAN}$1${NC}"
}

# ============================================================================
# VALIDACIONES
# ============================================================================

validate_structure() {
    print_info "Validando estructura..."
    
    if [ ! -d "$ASSET_GENERATED_DIR" ]; then
        print_error "Directorio de patrones generados no encontrado"
        echo "  Ruta: $ASSET_GENERATED_DIR"
        exit 1
    fi
    print_success "Directorio de patrones encontrado"
    
    if [ ! -f "$WEZTERM_CONFIG" ]; then
        print_warning "wezterm.lua no encontrado en: $WEZTERM_CONFIG"
        echo "  (Se saltará la copia de config)"
    else
        print_success "wezterm.lua encontrado"
    fi
}

# ============================================================================
# CREAR DIRECTORIO TARGET
# ============================================================================

create_target_dir() {
    if [ ! -d "$ASSET_TARGET_DIR" ]; then
        print_info "Creando directorio: $ASSET_TARGET_DIR"
        mkdir -p "$ASSET_TARGET_DIR"
        if [ $? -eq 0 ]; then
            print_success "Directorio creado"
        else
            print_error "No se pudo crear el directorio"
            exit 1
        fi
    else
        print_success "Directorio target ya existe"
    fi
}

# ============================================================================
# REGENERAR PATRONES (OPCIONAL)
# ============================================================================

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

# ============================================================================
# COPIAR SOLO ARCHIVOS NECESARIOS PARA LA CONFIG
# ============================================================================

copy_assets() {
    print_info "Copiando assets necesarios para la config..."
    echo -e "${GRAY}(Solo patrones generados y wallpaper)${NC}"
    echo ""
    
    local files_to_copy=(
        "WallpaperGemini.png|Wallpaper de fondo"
        "Patron_Espacio_Peque.png|Patrón de fondo lejano"
        "Patron_Espacio_Mediano.png|Patrón de fondo cercano"
    )
    
    local copied=0
    local missing=0
    
    for file_info in "${files_to_copy[@]}"; do
        IFS='|' read -r filename description <<< "$file_info"
        local source_path="$ASSET_GENERATED_DIR/$filename"
        
        if [ -f "$source_path" ]; then
            cp "$source_path" "$ASSET_TARGET_DIR/"
            if [ $? -eq 0 ]; then
                echo -e "  ${GREEN}✓ $filename${NC}"
                echo -e "  ${GRAY}    └─ $description${NC}"
                ((copied++))
            else
                echo -e "  ${RED}✗ Error copiando $filename${NC}"
                ((missing++))
            fi
        else
            echo -e "  ${RED}✗ $filename no encontrado${NC}"
            ((missing++))
        fi
    done
    
    echo ""
    
    if [ $copied -eq 0 ]; then
        print_error "No se encontraron archivos para copiar"
        exit 1
    fi
    
    print_success "$copied archivos copiados exitosamente"
    
    if [ $missing -gt 0 ]; then
        print_warning "$missing archivos faltantes (regenera con --generate-patterns si es necesario)"
    fi
}

# ============================================================================
# COPIAR WEZTERM.LUA
# ============================================================================

copy_wezterm_config() {
    if [ ! -f "$WEZTERM_CONFIG" ]; then
        print_warning "No se encontró wezterm.lua, se saltará su copia"
        return
    fi
    
    echo ""
    print_info "Copiando configuración de WezTerm..."
    
    cp "$WEZTERM_CONFIG" "$WEZTERM_TARGET"
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}✓ wezterm.lua${NC}"
        echo -e "  ${GRAY}    └─ Configuración principal${NC}"
        print_success "Configuración copiada a $WEZTERM_TARGET"
    else
        print_error "Error copiando wezterm.lua"
        return 1
    fi
}

# ============================================================================
# RESUMEN FINAL
# ============================================================================

print_summary() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    print_success "Setup completado exitosamente!"
    echo ""
    echo -e "${YELLOW}Próximos pasos:${NC}"
    echo -e "${GRAY}  1. Recarga WezTerm (Ctrl+Shift+R o reinicia la app)${NC}"
    echo ""
    echo -e "${YELLOW}Assets ubicados en:${NC}"
    echo -e "${GRAY}  $ASSET_TARGET_DIR${NC}"
    echo ""
    echo -e "${YELLOW}Config ubicada en:${NC}"
    echo -e "${GRAY}  $WEZTERM_TARGET${NC}"
    echo ""
    
    if [ "$GENERATE_PATTERNS" = false ]; then
        echo -e "${YELLOW}Para regenerar los patrones (si cambias stickers):${NC}"
        echo -e "${GRAY}  ./setup-assets.sh --generate-patterns${NC}"
        echo ""
    fi
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ============================================================================
# EJECUCIÓN PRINCIPAL
# ============================================================================

print_header
validate_structure
create_target_dir
echo ""
regenerate_patterns
copy_assets
copy_wezterm_config
print_summary
