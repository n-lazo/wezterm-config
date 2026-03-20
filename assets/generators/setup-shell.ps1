<#
.SYNOPSIS
    Configura Oh My Posh para PowerShell en Windows.
.DESCRIPTION
    Instala Oh My Posh mediante winget y lo añade al $PROFILE de PowerShell
    con el tema catppuccin_frappe.
#>

Write-Host "`n-- Configuración de Shell (Oh My Posh) --" -ForegroundColor Magenta

# 1. Verificar/Instalar Oh My Posh
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Oh My Posh con winget..." -ForegroundColor Yellow
    winget install --id JanDeDobbeleer.OhMyPosh --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Error instalando Oh My Posh" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Oh My Posh instalado." -ForegroundColor Green
} else {
    Write-Host "✓ Oh My Posh ya está instalado." -ForegroundColor Green
}

# 2. Configurar $PROFILE
Write-Host "Configurando perfil de PowerShell..." -ForegroundColor Cyan

$initLine = 'oh-my-posh init pwsh --config "catppuccin_frappe" | Invoke-Expression'

# Asegurar que el directorio del perfil existe
$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Asegurar que el archivo de perfil existe
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

# Leer contenido actual y verificar si ya existe la línea
$content = Get-Content $PROFILE -ErrorAction SilentlyContinue
if ($content -notcontains $initLine) {
    Add-Content -Path $PROFILE -Value "`n# Oh My Posh Init`n$initLine"
    Write-Host "✓ Inicialización añadida a $PROFILE" -ForegroundColor Green
} else {
    Write-Host "ℹ La inicialización ya existe en el perfil." -ForegroundColor Gray
}

Write-Host "`n✓ ¡Configuración completada! Reinicia la terminal para ver los cambios.`n" -ForegroundColor Green
