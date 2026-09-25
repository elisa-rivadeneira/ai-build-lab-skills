# Instalador del Skill "AI Build Lab" para Claude Code en Windows.
# Uso: pegar esto en una terminal de PowerShell y presionar Enter:
#   irm https://raw.githubusercontent.com/elisa-rivadeneira/ai-build-lab-skills/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$repoZipUrl   = "https://github.com/elisa-rivadeneira/ai-build-lab-skills/archive/refs/heads/main.zip"
$tempZip      = Join-Path $env:TEMP "ai-build-lab-skills.zip"
$tempExtract  = Join-Path $env:TEMP "ai-build-lab-skills-extract"
$targetDir    = Join-Path $env:USERPROFILE ".claude\skills"
$skillFolders = @("ai-build-lab-builder")

Write-Host "Descargando el Skill de AI Build Lab..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $repoZipUrl -OutFile $tempZip

if (Test-Path $tempExtract) { Remove-Item -Recurse -Force $tempExtract }
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

$extractedRoot = Get-ChildItem -Path $tempExtract -Directory | Select-Object -First 1

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

foreach ($folder in $skillFolders) {
    $source = Join-Path $extractedRoot.FullName $folder
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination $targetDir -Recurse -Force
        Write-Host "Instalado: $folder" -ForegroundColor Green
    }
}

Remove-Item -Recurse -Force $tempZip, $tempExtract -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Listo! El Skill de AI Build Lab ya esta instalado en tu computadora." -ForegroundColor Green
Write-Host "Abre Claude Code en cualquier carpeta de proyecto nueva, pega el prompt que te dio ChatGPT" -ForegroundColor Green
Write-Host "junto con la imagen de referencia, y Claude construira la aplicacion automaticamente." -ForegroundColor Green
