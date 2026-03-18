<#
.SYNOPSIS
    Genera patrones de espacio para WezTerm usando ImageMagick
.DESCRIPTION
    Script modularizado para generar patrones con efecto parallax.
    Requiere: ImageMagick (magick) y stickers de entrada.
.PARAMETER AssetDir
    Directorio donde están los stickers (Astronauta.png, Luna.png, etc.)
.PARAMETER OutputDir
    Directorio de salida (default: AssetDir)
.EXAMPLE
    .\generate-patterns.ps1 -AssetDir ".\assets\source"
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$AssetDir = "$env:USERPROFILE\.wezterm_assets",

    [Parameter(Mandatory=$false)]
    [string]$OutputDir = $null
)

# Si no se especifica OutputDir, usa el mismo AssetDir (para backward compatibility)
if (-not $OutputDir) { $OutputDir = $AssetDir }

# ============================================================================
# VALIDACIONES Y SETUP
# ============================================================================

function Test-ImageMagick {
    try {
        $version = magick --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ ImageMagick encontrado: $(($version | Select-Object -First 1))" -ForegroundColor Green
            return $true
        }
    } catch {}
    
    Write-Host "✗ ImageMagick no encontrado. Instálalo desde: https://imagemagick.org/" -ForegroundColor Red
    return $false
}

function Test-AssetDirectory {
    if (-not (Test-Path $AssetDir)) {
        Write-Host "✗ Directorio de assets no encontrado: $AssetDir" -ForegroundColor Red
        return $false
    }
    Write-Host "✓ Assets directory: $AssetDir" -ForegroundColor Green
    return $true
}

function Test-RequiredStickers {
    $required = @("Astronauta.png", "Luna.png", "Nave.png", "Galaxia.png")
    $missing = @()
    
    foreach ($sticker in $required) {
        $path = Join-Path $AssetDir $sticker
        if (-not (Test-Path $path)) {
            $missing += $sticker
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Host "✗ Stickers faltantes: $($missing -join ', ')" -ForegroundColor Red
        return $false
    }
    
    Write-Host "✓ Todos los stickers requeridos encontrados" -ForegroundColor Green
    return $true
}

# ============================================================================
# FUNCIONES GENERADORAS
# ============================================================================

function Generate-OrganicTiledPattern {
    param(
        [string]$Filename,
        [int]$MinSize = 100,
        [int]$MaxSize = 150,
        [int]$Cols = 3,
        [int]$Rows = 4
    )
    
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Generando: $Filename" -ForegroundColor Cyan
    Write-Host "Dimensiones: $Cols cols × $Rows rows (desfasado)" -ForegroundColor Cyan
    Write-Host "Tamaño de stickers: $MinSize-$MaxSize px" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    
    $outputPath = Join-Path $OutputDir $Filename
    $canvasWidth = 2000
    $canvasHeight = 4000
    
    # 1. Crear lienzo transparente
    & magick -size "$($canvasWidth)x$($canvasHeight)" xc:none -type TrueColorAlpha $outputPath
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Error creando lienzo" -ForegroundColor Red
        return $false
    }
    
    # 2. Calcular dimensiones de celda
    $cellW = [math]::Floor($canvasWidth / $Cols)
    $cellH = [math]::Floor($canvasHeight / ($Rows + 0.5))
    $safetyMargin = 60
    
    # 3. Crear matriz para tracking de stickers usados
    $chosenGrid = New-Object 'string[,]' $Rows, $Cols
    $baseStickers = @(
        @{ file = "Astronauta.png"; path = (Join-Path $AssetDir "Astronauta.png") },
        @{ file = "Luna.png"; path = (Join-Path $AssetDir "Luna.png") },
        @{ file = "Nave.png"; path = (Join-Path $AssetDir "Nave.png") },
        @{ file = "Galaxia.png"; path = (Join-Path $AssetDir "Galaxia.png") }
    )
    
    # 4. Bucle a través de la grilla
    for ($r = 0; $r -lt $Rows; $r++) {
        for ($c = 0; $c -lt $Cols; $c++) {
            # Evitar duplicados adyacentes
            $leftNeighbor = $null
            $topNeighbor = $null
            if ($c -gt 0) { $leftNeighbor = $chosenGrid[$r, ($c - 1)] }
            if ($r -gt 0) { $topNeighbor = $chosenGrid[($r - 1), $c] }
            
            $forbiddenFiles = @()
            if ($leftNeighbor) { $forbiddenFiles += $leftNeighbor }
            if ($topNeighbor) { $forbiddenFiles += $topNeighbor }
            
            # Elegir sticker disponible
            $availablePool = $baseStickers | Where-Object { $forbiddenFiles -notcontains $_.file }
            $chosen = $availablePool | Get-Random
            $chosenGrid[$r, $c] = $chosen.file
            
            # Calcular posición con desfase (stagger)
            $finalW = Get-Random -Minimum $MinSize -Maximum $MaxSize
            $baseX = $c * $cellW
            $baseY = $r * $cellH
            
            # Stagger: columnas impares se desplazan hacia abajo
            if ($c % 2 -ne 0) {
                $baseY += [math]::Floor($cellH / 2)
            }
            
            # Jitter para mayor naturalidad
            $maxX = [math]::Max($safetyMargin + 1, $cellW - $finalW - $safetyMargin)
            $maxY = [math]::Max($safetyMargin + 1, $cellH - $finalW - $safetyMargin)
            
            $jitterX = Get-Random -Minimum $safetyMargin -Maximum $maxX
            $jitterY = Get-Random -Minimum $safetyMargin -Maximum $maxY
            
            $finalX = $baseX + $jitterX
            $finalY = $baseY + $jitterY
            
            # Compositar sticker en el lienzo
            $stickerImg = $chosen.path + "[x$finalW]"
            & magick $outputPath $stickerImg -geometry "+$finalX+$finalY" -colorspace sRGB -composite $outputPath
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✓ Celda [$r,$c]: $($chosen.file) @ ($finalX, $finalY)" -ForegroundColor Green
            } else {
                Write-Host "  ✗ Error en celda [$r,$c]" -ForegroundColor Red
                return $false
            }
        }
    }
    
    # 5. Optimizar PNG
    & magick $outputPath -type TrueColorAlpha -define png:color-type=6 $outputPath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Error optimizando PNG" -ForegroundColor Red
        return $false
    }
    
    Write-Host "✓ $Filename generado exitosamente" -ForegroundColor Green
    return $true
}

# ============================================================================
# EJECUCIÓN PRINCIPAL
# ============================================================================

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║   GENERADOR DE PATRONES PARALLAX PARA WEZTERM         ║" -ForegroundColor Magenta
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# Validaciones
if (-not (Test-ImageMagick)) { exit 1 }
if (-not (Test-AssetDirectory)) { exit 1 }
if (-not (Test-RequiredStickers)) { exit 1 }

$success = $true

# Generar patrones
if (-not (Generate-OrganicTiledPattern "Patron_Espacio_Peque.png" 100 150 3 4)) { $success = $false }
if (-not (Generate-OrganicTiledPattern "Patron_Espacio_Mediano.png" 200 300 3 3)) { $success = $false }

# Resumen final
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
if ($success) {
    Write-Host "✓ ¡Generación completada exitosamente!" -ForegroundColor Green
    Write-Host "  Los patrones están en: $OutputDir" -ForegroundColor Green
} else {
    Write-Host "✗ La generación tuvo errores" -ForegroundColor Red
    exit 1
}
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
