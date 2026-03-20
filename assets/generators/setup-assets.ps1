<#
.SYNOPSIS
    Script de setup para WezTerm
.DESCRIPTION
    Configura WezTerm. Requiere que el repo esté clonado en el directorio de config de WezTerm:
      Windows : git clone <repo> $env:USERPROFILE\.config\wezterm
      Linux   : git clone <repo> ~/.config/wezterm
    - Verifica WezTerm
    - Opcionalmente instala dependencias con winget
    - Opcionalmente regenera los patrones parallax con ImageMagick
.PARAMETER GeneratePatterns
    Si se especifica, regenera los patrones con ImageMagick
.PARAMETER InstallDeps
    Si se especifica, instala WezTerm e ImageMagick con winget
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

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║           SETUP DE WEZTERM                                    ║" -ForegroundColor Magenta
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
    Write-Host "  Asegúrate de haber clonado el repo con Git LFS habilitado." -ForegroundColor Gray
    exit 1
}
Write-Host "✓ Directorio de patrones encontrado" -ForegroundColor Green
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
# RESUMEN FINAL
# ============================================================================

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✓ Setup completado exitosamente!" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Recarga WezTerm (Ctrl+Shift+R o reinicia la app)" -ForegroundColor Gray
Write-Host ""

if (-not $GeneratePatterns) {
    Write-Host "Para regenerar los patrones (si cambias stickers):" -ForegroundColor Yellow
    Write-Host "  .\setup-assets.ps1 -GeneratePatterns" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
