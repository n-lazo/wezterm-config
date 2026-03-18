<#
.SYNOPSIS
    Script de setup para WezTerm - copia/valida assets
.DESCRIPTION
    Configura el directorio de assets para WezTerm.
    - Copia assets desde este repo al home directory
    - Genera patrones parallax si se especifica
.PARAMETER GeneratePatterns
    Si es $true, regenera los patrones con generate-patterns.ps1
.EXAMPLE
    .\setup-assets.ps1 -GeneratePatterns $true
#>

param(
    [Parameter(Mandatory=$false)]
    [switch]$GeneratePatterns = $false
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$assetSourceDir = Join-Path $scriptRoot "..\assets\source"
$assetTargetDir = "$env:USERPROFILE\.wezterm_assets"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║           SETUP DE ASSETS PARA WEZTERM                ║" -ForegroundColor Magenta
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# ============================================================================
# VALIDACIONES
# ============================================================================

Write-Host "Validando estructura..." -ForegroundColor Cyan
if (-not (Test-Path $assetSourceDir)) {
    Write-Host "✗ Directorio de assets no encontrado: $assetSourceDir" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Directorio de assets encontrado: $assetSourceDir" -ForegroundColor Green

# ============================================================================
# CREAR DIRECTORIO TARGET
# ============================================================================

if (-not (Test-Path $assetTargetDir)) {
    Write-Host "Creando directorio: $assetTargetDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $assetTargetDir | Out-Null
    Write-Host "✓ Directorio creado" -ForegroundColor Green
} else {
    Write-Host "✓ Directorio target ya existe: $assetTargetDir" -ForegroundColor Green
}

# ============================================================================
# COPIAR ASSETS
# ============================================================================

Write-Host ""
Write-Host "Copiando assets..." -ForegroundColor Cyan

$files = Get-ChildItem $assetSourceDir -File
$copied = 0

foreach ($file in $files) {
    $targetPath = Join-Path $assetTargetDir $file.Name
    Copy-Item -Path $file.FullName -Destination $targetPath -Force
    Write-Host "  ✓ $($file.Name)" -ForegroundColor Green
    $copied++
}

if ($copied -eq 0) {
    Write-Host "✗ No se encontraron archivos para copiar" -ForegroundColor Red
    exit 1
}

Write-Host "✓ $copied archivos copiados" -ForegroundColor Green

# ============================================================================
# GENERAR PATRONES (opcional)
# ============================================================================

if ($GeneratePatterns) {
    Write-Host ""
    Write-Host "Regenerando patrones parallax..." -ForegroundColor Cyan
    
    $generateScript = Join-Path $scriptRoot "generate-patterns.ps1"
    if (Test-Path $generateScript) {
        & $generateScript -AssetDir $assetTargetDir -OutputDir $assetTargetDir
        if ($LASTEXITCODE -ne 0) {
            Write-Host "✗ Error en la generación de patrones" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "⚠ Script de generación no encontrado: $generateScript" -ForegroundColor Yellow
    }
}

# ============================================================================
# RESUMEN FINAL
# ============================================================================

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✓ Setup completado exitosamente!" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Copia wezterm.lua a: $env:USERPROFILE\.wezterm.lua" -ForegroundColor Gray
Write-Host "  2. Recarga WezTerm (Ctrl+Shift+R o reinicia la app)" -ForegroundColor Gray
Write-Host ""
if (-not $GeneratePatterns) {
    Write-Host "Para regenerar los patrones parallax, ejecuta:" -ForegroundColor Yellow
    Write-Host "  .\setup-assets.ps1 -GeneratePatterns" -ForegroundColor Gray
}
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
