$ErrorActionPreference = 'Stop'

$coreDir = Join-Path $PSScriptRoot "..\bind\windows\core"
$releaseDir = Join-Path $PSScriptRoot "..\build\windows\x64\runner\Release"

New-Item -ItemType Directory -Force -Path $coreDir | Out-Null
New-Item -ItemType Directory -Force -Path $releaseDir | Out-Null

Write-Host "Fetching latest Mihomo core for Windows x64..." -ForegroundColor Cyan
$zipUrl = "https://github.com/MetaCubeX/mihomo/releases/download/v1.19.2/mihomo-windows-amd64-v1.19.2.zip"
$zipPath = Join-Path $coreDir "mihomo.zip"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing

$tempDir = Join-Path $coreDir "temp"
Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
$exe = Get-ChildItem -Path $tempDir -Filter "*.exe" | Select-Object -First 1

if ($exe) {
    $dest1 = Join-Path $coreDir "wmimoService.exe"
    $dest2 = Join-Path $releaseDir "wmimoService.exe"
    Copy-Item -Path $exe.FullName -Destination $dest1 -Force
    Copy-Item -Path $exe.FullName -Destination $dest2 -Force
    Remove-Item -Path $tempDir -Recurse -Force
    Remove-Item -Path $zipPath -Force
    Write-Host "Mihomo core successfully installed to:" -ForegroundColor Green
    Write-Host "  -> $dest1"
    Write-Host "  -> $dest2"
} else {
    Write-Error "Failed to locate mihomo .exe file in archive."
}
