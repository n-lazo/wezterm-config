<#
.SYNOPSIS
    Script de mantenimiento para assets de WezTerm
.DESCRIPTION
    Verifica el entorno y opcionalmente regenera los patrones parallax.
    Uso: .\setup-assets.ps1 [-GeneratePatterns] [-InstallDeps]
#>

param(
    [switch]$GeneratePatterns = $false,
    [switch]$InstallDeps = $false
)

$scriptRoot = $PSScriptRoot
$assetGeneratedDir = Join-Path $scriptRoot "..\generated"
$assetSourcesDir = Join-Path $scriptRoot "..\sources"

Write-Host "`n-- WezTerm Asset Setup --" -ForegroundColor Magenta

# 1. Verificar WezTerm
if (-not (Get-Command wezterm -ErrorAction SilentlyContinue)) {
    if ($InstallDeps) {
        Write-Host "Instalando WezTerm..." -ForegroundColor Yellow
        winget install --id wez.wezterm --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "⚠ WezTerm no encontrado en el PATH." -ForegroundColor Yellow
    }
} else {
    Write-Host "✓ WezTerm detectado" -ForegroundColor Green
}

# 2. Validar estructura
if (-not (Test-Path $assetGeneratedDir)) {
    Write-Host "✗ Error: No se encuentra el directorio de assets generados." -ForegroundColor Red
    Write-Host "  Asegúrate de haber descargado los archivos con Git LFS: git lfs pull" -ForegroundColor Gray
    exit 1
}

# 3. Regenerar patrones (opcional)
if ($GeneratePatterns) {
    $genScript = Join-Path $scriptRoot "generate-patterns.ps1"
    if (Test-Path $genScript) {
        & $genScript -AssetDir $assetSourcesDir -OutputDir $assetGeneratedDir -InstallDeps:$InstallDeps
    } else {
        Write-Host "✗ Error: No se encuentra generate-patterns.ps1" -ForegroundColor Red
    }
}

Write-Host "`n✓ ¡Listo! Recarga WezTerm (Ctrl+Shift+R)`n" -ForegroundColor Green
