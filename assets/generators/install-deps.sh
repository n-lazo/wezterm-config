#!/bin/bash

################################################################################
# INSTALADOR DE DEPENDENCIAS
# Guía rápida para instalar ImageMagick en diferentes plataformas.
################################################################################

MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "\n${MAGENTA}-- Instalador de Dependencias (ImageMagick) --${NC}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Para macOS (Homebrew):"
    echo "  brew install imagemagick"
elif command -v apt-get &>/dev/null; then
    echo "Para Ubuntu/Debian:"
    echo "  sudo apt update && sudo apt install imagemagick"
elif command -v pacman &>/dev/null; then
    echo "Para Arch Linux:"
    echo "  sudo pacman -S imagemagick"
else
    echo "Por favor, instala ImageMagick usando el gestor de paquetes de tu distribución."
fi

echo -e "\n${GREEN}✓ Consulta SETUP.md para una guía detallada.${NC}\n"
