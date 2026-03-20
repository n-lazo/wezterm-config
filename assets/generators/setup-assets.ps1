<#
.SYNOPSIS
    Script de setup para WezTerm - copia assets necesarios
.DESCRIPTION
    Configura el directorio de assets para WezTerm.
    - Copia SOLO los patrones generados y wallpaper (lo que usa la config)
    - NO copia stickers (solo se usan para generar patrones)
    - Opcionalmente regenera los patrones si deseas cambiar stickers
.PARAMETER GeneratePatterns
    Si se especifica, regenera los patrones antes de copiar
.PARAMETER InstallDeps
    Si se especifica, instala WezTerm e ImageMagick automáticamente con winget si no están presentes
.EXAMPLE
    .\setup-assets.ps1
    .\setup-assets.ps1 -InstallDeps
    .\setup-assets.ps1 -GeneratePatterns -InstallDeps
#>

param(
    [Parameter(Mandatory=$false)]
    [switch]$GeneratePatterns = $false,

    [Parameter(Mandatory=$false)]
    [switch]$InstallDeps = $false
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$assetGeneratedDir = Join-Path $scriptRoot "..\generated"
$assetSourcesDir = Join-Path $scriptRoot "..\sources"
$assetTargetDir = "$env:USERPROFILE\.wezterm_assets"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║           SETUP DE ASSETS PARA WEZTERM                        ║" -ForegroundColor Magenta
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# ============================================================================
# INSTALAR WEZTERM
# ============================================================================

Write-Host "Verificando WezTerm..." -ForegroundColor Cyan

$weztermInstalled = Get-Command wezterm -ErrorAction SilentlyContinue
if ($weztermInstalled) {
    Write-Host "✓ WezTerm ya está instalado" -ForegroundColor Green
} elseif ($InstallDeps) {
    Write-Host "Instalando WezTerm con winget..." -ForegroundColor Yellow
    winget install --id wez.wezterm --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Error instalando WezTerm" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ WezTerm instalado correctamente" -ForegroundColor Green
} else {
    Write-Host "⚠ WezTerm no encontrado. Usa -InstallDeps para instalarlo automáticamente." -ForegroundColor Yellow
}

Write-Host ""

# ============================================================================
# VALIDACIONES
# ============================================================================

Write-Host "Validando estructura..." -ForegroundColor Cyan
if (-not (Test-Path $assetGeneratedDir)) {
    Write-Host "✗ Directorio de patrones generados no encontrado" -ForegroundColor Red
    Write-Host "  Ruta: $assetGeneratedDir" -ForegroundColor Gray
    exit 1
}
Write-Host "✓ Directorio de patrones encontrado" -ForegroundColor Green

# ============================================================================
# CREAR DIRECTORIO TARGET
# ============================================================================

if (-not (Test-Path $assetTargetDir)) {
    Write-Host "Creando directorio: $assetTargetDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $assetTargetDir | Out-Null
    Write-Host "✓ Directorio creado" -ForegroundColor Green
} else {
    Write-Host "✓ Directorio target ya existe" -ForegroundColor Green
}

Write-Host ""

# ============================================================================
# REGENERAR PATRONES (opcional)
# ============================================================================

if ($GeneratePatterns) {
    Write-Host "Regenerando patrones parallax..." -ForegroundColor Cyan
    
    $generateScript = Join-Path $scriptRoot "generate-patterns.ps1"
    if (Test-Path $generateScript) {
        & $generateScript -AssetDir $assetSourcesDir -OutputDir $assetGeneratedDir -InstallDeps:$InstallDeps
        if ($LASTEXITCODE -ne 0) {
            Write-Host "✗ Error en la generación de patrones" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "⚠ Script de generación no encontrado: $generateScript" -ForegroundColor Yellow
    }
    
    Write-Host ""
}

# ============================================================================
# COPIAR SOLO ARCHIVOS NECESARIOS PARA LA CONFIG
# ============================================================================

Write-Host "Copiando assets necesarios para la config..." -ForegroundColor Cyan
Write-Host "(Solo patrones generados y wallpaper)" -ForegroundColor Gray
Write-Host ""

$filesToCopy = @(
    @{ 
        Source = "WallpaperGemini.png"
        Description = "Wallpaper de fondo"
    },
    @{ 
        Source = "Patron_Espacio_Peque.png"
        Description = "Patrón de fondo lejano"
    },
    @{ 
        Source = "Patron_Espacio_Mediano.png"
        Description = "Patrón de fondo cercano"
    }
)

$copied = 0
$missing = 0

foreach ($fileInfo in $filesToCopy) {
    $sourcePath = Join-Path $assetGeneratedDir $fileInfo.Source
    
    if (Test-Path $sourcePath) {
        $targetPath = Join-Path $assetTargetDir $fileInfo.Source
        Copy-Item -Path $sourcePath -Destination $targetPath -Force
        Write-Host "  ✓ $($fileInfo.Source)" -ForegroundColor Green
        Write-Host "    └─ $($fileInfo.Description)" -ForegroundColor Gray
        $copied++
    } else {
        Write-Host "  ✗ $($fileInfo.Source) no encontrado" -ForegroundColor Red
        $missing++
    }
}

Write-Host ""

if ($copied -eq 0) {
    Write-Host "✗ No se encontraron archivos para copiar" -ForegroundColor Red
    exit 1
}

Write-Host "✓ $copied archivos copiados exitosamente" -ForegroundColor Green

if ($missing -gt 0) {
    Write-Host "⚠ $missing archivos faltantes (regenera con -GeneratePatterns si es necesario)" -ForegroundColor Yellow
}

# ============================================================================
# RESUMEN FINAL
# ============================================================================

# ============================================================================
# COPIAR WEZTERM.LUA
# ============================================================================

Write-Host ""
Write-Host "Copiando configuración de WezTerm..." -ForegroundColor Cyan

$weztermConfigPath = Join-Path (Split-Path (Split-Path $scriptRoot -Parent) -Parent) "wezterm.lua"
$weztermTargetPath = Join-Path $env:USERPROFILE ".wezterm.lua"

if (Test-Path $weztermConfigPath) {
    Copy-Item -Path $weztermConfigPath -Destination $weztermTargetPath -Force
    Write-Host "  ✓ wezterm.lua" -ForegroundColor Green
    Write-Host "    └─ Configuración principal" -ForegroundColor Gray
    Write-Host "✓ Configuración copiada a: $weztermTargetPath" -ForegroundColor Green
} else {
    Write-Host "⚠ wezterm.lua no encontrado en: $weztermConfigPath" -ForegroundColor Yellow
    Write-Host "  Se omite su copia" -ForegroundColor Gray
}

# ============================================================================
# RESUMEN FINAL
# ============================================================================

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✓ Setup completado exitosamente!" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Recarga WezTerm (Ctrl+Shift+R o reinicia la app)" -ForegroundColor Gray
Write-Host ""
Write-Host "Assets ubicados en:" -ForegroundColor Yellow
Write-Host "  $assetTargetDir" -ForegroundColor Gray
Write-Host ""
Write-Host "Config ubicada en:" -ForegroundColor Yellow
Write-Host "  $weztermTargetPath" -ForegroundColor Gray
Write-Host ""

if (-not $GeneratePatterns) {
    Write-Host "Para regenerar los patrones (si cambias stickers):" -ForegroundColor Yellow
    Write-Host "  .\setup-assets.ps1 -GeneratePatterns" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
