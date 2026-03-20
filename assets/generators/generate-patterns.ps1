<#
.SYNOPSIS
    Genera patrones de espacio para WezTerm usando ImageMagick
.DESCRIPTION
    Genera los patrones parallax (pequeño y mediano) a partir de los stickers en assets/sources.
    Requiere: ImageMagick (magick).
.PARAMETER AssetDir
    Directorio de stickers de entrada (default: ..\sources)
.PARAMETER OutputDir
    Directorio de salida (default: ..\generated)
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$AssetDir = "$PSScriptRoot\..\sources",

    [Parameter(Mandatory=$false)]
    [string]$OutputDir = "$PSScriptRoot\..\generated",

    [Parameter(Mandatory=$false)]
    [switch]$InstallDeps = $false
)

# ============================================================================
# VALIDACIONES Y SETUP
# ============================================================================

function Test-ImageMagick {
    try {
        $version = magick --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ ImageMagick encontrado" -ForegroundColor Green
            return $true
        }
    } catch {}

    if ($InstallDeps) {
        Write-Host "ImageMagick no encontrado. Instalando con winget..." -ForegroundColor Yellow
        winget install --id ImageMagick.ImageMagick --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            Write-Host "✗ Error instalando ImageMagick" -ForegroundColor Red
            return $false
        }
        Write-Host "✓ ImageMagick instalado. Reinicia la terminal y vuelve a ejecutar el script." -ForegroundColor Green
    } else {
        Write-Host "✗ ImageMagick no encontrado. Instálalo desde https://imagemagick.org/" -ForegroundColor Red
    }
    return $false
}

function Test-RequiredStickers {
    $required = @("Astronauta.png", "Luna.png", "Nave.png", "Galaxia.png")
    $missing = @()
    
    foreach ($sticker in $required) {
        $path = Join-Path $AssetDir $sticker
        if (-not (Test-Path $path)) { $missing += $sticker }
    }
    
    if ($missing.Count -gt 0) {
        Write-Host "✗ Stickers faltantes en $AssetDir: $($missing -join ', ')" -ForegroundColor Red
        return $false
    }
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
    
    Write-Host "Generando: $Filename ($Cols x $Rows)..." -ForegroundColor Cyan
    
    $outputPath = Join-Path $OutputDir $Filename
    $canvasWidth = 2000
    $canvasHeight = 4000
    
    # 1. Crear lienzo transparente
    & magick -size "$($canvasWidth)x$($canvasHeight)" xc:none -type TrueColorAlpha $outputPath
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Error creando lienzo" -ForegroundColor Red
        return $false
    }
    
    $cellW = [math]::Floor($canvasWidth / $Cols)
    $cellH = [math]::Floor($canvasHeight / ($Rows + 0.5))
    $safetyMargin = 60
    
    $baseStickers = @(
        @{ file = "Astronauta.png"; path = (Join-Path $AssetDir "Astronauta.png") },
        @{ file = "Luna.png"; path = (Join-Path $AssetDir "Luna.png") },
        @{ file = "Nave.png"; path = (Join-Path $AssetDir "Nave.png") },
        @{ file = "Galaxia.png"; path = (Join-Path $AssetDir "Galaxia.png") }
    )
    
    $chosenGrid = New-Object 'string[,]' $Rows, $Cols

    for ($r = 0; $r -lt $Rows; $r++) {
        for ($c = 0; $c -lt $Cols; $c++) {
            $forbiddenFiles = @()
            if ($c -gt 0) { $forbiddenFiles += $chosenGrid[$r, ($c - 1)] }
            if ($r -gt 0) { $forbiddenFiles += $chosenGrid[($r - 1), $c] }
            
            $availablePool = $baseStickers | Where-Object { $forbiddenFiles -notcontains $_.file }
            $chosen = $availablePool | Get-Random
            $chosenGrid[$r, $c] = $chosen.file
            
            $finalW = Get-Random -Minimum $MinSize -Maximum $MaxSize
            $baseX = $c * $cellW
            $baseY = $r * $cellH
            
            if ($c % 2 -ne 0) { $baseY += [math]::Floor($cellH / 2) }
            
            $maxX = [math]::Max($safetyMargin + 1, $cellW - $finalW - $safetyMargin)
            $maxY = [math]::Max($safetyMargin + 1, $cellH - $finalW - $safetyMargin)
            
            $jitterX = Get-Random -Minimum $safetyMargin -Maximum $maxX
            $jitterY = Get-Random -Minimum $safetyMargin -Maximum $maxY
            
            $finalX = $baseX + $jitterX
            $finalY = $baseY + $jitterY
            
            & magick $outputPath ($chosen.path + "[x$finalW]") -geometry "+$finalX+$finalY" -colorspace sRGB -composite $outputPath
        }
    }
    
    & magick $outputPath -type TrueColorAlpha -define png:color-type=6 $outputPath
    Write-Host "✓ Guardado en $outputPath" -ForegroundColor Green
    return $true
}

# ============================================================================
# EJECUCIÓN
# ============================================================================

Write-Host "`n-- Generador de Patrones Parallax --" -ForegroundColor Magenta

if (-not (Test-ImageMagick)) { exit 1 }
if (-not (Test-RequiredStickers)) { exit 1 }

if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir | Out-Null }

$success = $true
if (-not (Generate-OrganicTiledPattern "Patron_Espacio_Peque.png" 100 150 3 4)) { $success = $false }
if (-not (Generate-OrganicTiledPattern "Patron_Espacio_Mediano.png" 200 300 3 3)) { $success = $false }

if (-not $success) { exit 1 }
Write-Host "¡Completado!`n" -ForegroundColor Green
