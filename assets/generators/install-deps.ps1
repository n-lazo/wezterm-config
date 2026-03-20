<#
.SYNOPSIS
    Instala las dependencias necesarias para los generadores de assets.
.DESCRIPTION
    Instala ImageMagick (requerido para los patrones) y opcionalmente WezTerm.
    Uso: .\install-deps.ps1 [-WezTerm]
#>

param(
    [switch]$WezTerm = $false
)

Write-Host "`n-- Instalador de Dependencias --" -ForegroundColor Magenta

if ($WezTerm) {
    Write-Host "Instalando WezTerm..." -ForegroundColor Yellow
    winget install --id wez.wezterm --accept-package-agreements --accept-source-agreements
}

Write-Host "Instalando ImageMagick..." -ForegroundColor Yellow
winget install --id ImageMagick.ImageMagick --accept-package-agreements --accept-source-agreements

Write-Host "`n✓ Instalación finalizada. Reinicia la terminal para que los cambios surtan efecto.`n" -ForegroundColor Green
