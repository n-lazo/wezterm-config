<#
.SYNOPSIS
    Generador de patrones parallax para WezTerm
.DESCRIPTION
    Verifica el entorno y genera los patrones parallax (pequeño y mediano)
    a partir de los stickers en assets/sources.
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
    [string]$OutputDir = "$PSScriptRoot\..\generated"
)

# ============================================================================
# FUNCIONES DE APOYO
# ============================================================================

function Test-Environment {
    # 1. Verificar ImageMagick
    try {
        $null = magick --version 2>&1
        if ($LASTEXITCODE -ne 0) { throw }
    } catch {
        Write-Host "✗ Error: ImageMagick no encontrado." -ForegroundColor Red
        Write-Host "  Ejecuta .\install-deps.ps1 para instalarlo." -ForegroundColor Gray
        return $false
    }

    # 2. Validar stickers requeridos
    $required = @("Astronauta.png", "Luna.png", "Nave.png", "Galaxia.png")
    foreach ($sticker in $required) {
        if (-not (Test-Path (Join-Path $AssetDir $sticker))) {
            Write-Host "✗ Error: Falta $sticker en $AssetDir" -ForegroundColor Red
            return $false
        }
    }

    # 3. Asegurar directorio de salida
    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir | Out-Null
    }

    return $true
}

function Generate-Pattern {
    param([string]$Filename, [int]$MinSize, [int]$MaxSize, [int]$Cols, [int]$Rows)
    
    Write-Host "Generando: $Filename ($Cols x $Rows)..." -ForegroundColor Cyan
    $outputPath = Join-Path $OutputDir $Filename
    $canvasWidth = 2000
    $canvasHeight = 4000
    
    & magick -size "$($canvasWidth)x$($canvasHeight)" xc:none -type TrueColorAlpha $outputPath
    if ($LASTEXITCODE -ne 0) { return $false }
    
    $cellW = [math]::Floor($canvasWidth / $Cols)
    $cellH = [math]::Floor($canvasHeight / ($Rows + 0.5))
    $safetyMargin = 60
    
    $stickers = @("Astronauta.png", "Luna.png", "Nave.png", "Galaxia.png")
    $chosenGrid = New-Object 'string[,]' $Rows, $Cols

    for ($r = 0; $r -lt $Rows; $r++) {
        for ($c = 0; $c -lt $Cols; $c++) {
            $forbidden = @()
            if ($c -gt 0) { $forbidden += $chosenGrid[$r, ($c - 1)] }
            if ($r -gt 0) { $forbidden += $chosenGrid[($r - 1), $c] }
            
            $available = $stickers | Where-Object { $forbidden -notcontains $_ }
            $chosen = $available | Get-Random
            $chosenGrid[$r, $c] = $chosen
            
            $finalW = Get-Random -Minimum $MinSize -Maximum $MaxSize
            $baseX = $c * $cellW
            $baseY = $r * $cellH
            if ($c % 2 -ne 0) { $baseY += [math]::Floor($cellH / 2) }
            
            $finalX = $baseX + (Get-Random -Minimum $safetyMargin -Maximum ([math]::Max($safetyMargin + 1, $cellW - $finalW - $safetyMargin)))
            $finalY = $baseY + (Get-Random -Minimum $safetyMargin -Maximum ([math]::Max($safetyMargin + 1, $cellH - $finalW - $safetyMargin)))
            
            & magick $outputPath (Join-Path $AssetDir $chosen + "[x$finalW]") -geometry "+$finalX+$finalY" -colorspace sRGB -composite $outputPath
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

if (-not (Test-Environment)) { exit 1 }

$success = $true
if (-not (Generate-Pattern "Patron_Espacio_Peque.png" 100 150 3 4)) { $success = $false }
if (-not (Generate-Pattern "Patron_Espacio_Mediano.png" 200 300 3 3)) { $success = $false }

if ($success) {
    Write-Host "`n✓ ¡Patrones generados exitosamente! Recarga WezTerm (Ctrl+Shift+R)`n" -ForegroundColor Green
} else {
    Write-Host "`n✗ Hubo errores durante la generación.`n" -ForegroundColor Red
    exit 1
}
