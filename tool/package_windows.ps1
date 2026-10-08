param (
    [string]$Tag = "v1.2.1.1503"
)

$ErrorActionPreference = "Stop"

if (-not $Tag -or $Tag -eq "" -or $Tag -eq "main") {
    if (Test-Path "pubspec.yaml") {
        $pubVer = (Get-Content "pubspec.yaml" | Select-String -Pattern '^version:\s*(\S+)').Matches.Groups[1].Value.Split('+')[0]
        $pubBuild = (Get-Content "pubspec.yaml" | Select-String -Pattern '^version:\s*(\S+)').Matches.Groups[1].Value.Split('+')[1]
        if ($pubBuild) {
            $Tag = "v$pubVer.$pubBuild"
        } else {
            $Tag = "v$pubVer"
        }
    } else {
        $Tag = "v1.2.1.1503"
    }
}

$releasePath = (Resolve-Path "build/windows/x64/runner/Release").Path
$distDir = New-Item -ItemType Directory -Force -Path "dist"
$distPath = $distDir.FullName

# Copy core and wintun.dll
$corePath = "bind/windows/core/wmimoService.exe"
if (Test-Path $corePath) {
    Copy-Item -Path $corePath -Destination "$releasePath/wmimoService.exe" -Force
}
$wintunPath = "bind/windows/core/wintun.dll"
if (Test-Path $wintunPath) {
    Copy-Item -Path $wintunPath -Destination "$releasePath/wintun.dll" -Force
}

# Inno Setup compiler
$iscc = "ISCC.exe"
if (Test-Path "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe") {
    $iscc = "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
} elseif (Test-Path "C:\Program Files (x86)\Inno Setup 6\ISCC.exe") {
    $iscc = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
}

if (-not $Tag.StartsWith("v")) {
    $Tag = "v$Tag"
}
$rawVer = $Tag.TrimStart('v')

# 1. Create clean Portable (免安装绿色版) directory
$portableDir = "$distPath/Wmimo-Windows-x64-$Tag"
Write-Host "Preparing Portable Standalone folder at $portableDir..." -ForegroundColor Cyan
if (Test-Path $portableDir) {
    Remove-Item -Path $portableDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $portableDir | Out-Null
Get-ChildItem -Path $releasePath -Exclude "*.pdb" | Copy-Item -Destination $portableDir -Recurse -Force

# 2. Create Portable Zip archives
Write-Host "Creating Portable Zip archive..." -ForegroundColor Cyan
$zipName = "Wmimo-Windows-x64-$Tag.zip"
$zipPath = "$distPath/$zipName"
if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}
Compress-Archive -Path "$portableDir/*" -DestinationPath $zipPath -Force

$zipPortableName = "Wmimo-Windows-x64-Portable-$Tag.zip"
$zipPortablePath = "$distPath/$zipPortableName"
Copy-Item -Path $zipPath -Destination $zipPortablePath -Force

# 3. Compile Inno Setup Installer if compiler exists
if (Test-Path $iscc) {
    Write-Host "Compiling Inno Setup Installer for Windows x64 ($Tag, rawVersion: $rawVer)..." -ForegroundColor Cyan
    & $iscc "/DMyAppVersion=$rawVer" "/DMyAppArch=x64" "/DSourceDir=$releasePath" "/DOutputDir=$distPath" packaging/windows/setup.iss
}

Write-Host "==========================================" -ForegroundColor Green
Write-Host "Successfully generated Windows artifacts in dist/:" -ForegroundColor Green
Get-ChildItem -Path $distPath | Select-Object Name, Length, LastWriteTime
Write-Host "==========================================" -ForegroundColor Green
