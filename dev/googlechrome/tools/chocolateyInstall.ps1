$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

$version = '109.0.5414.149'
if ($version -eq (Get-ChromeVersion)) {
    Write-Host "Google Chrome $version is already installed."
    return
}

$packageArgs = @{
    packageName    = 'googlechrome'
    fileType       = 'MSI'
    url            = 'https://edgedl.me.gvt1.com/edgedl/release2/10/windows-8/googlechromestandaloneenterprise.msi'
    url64bit       = 'https://edgedl.me.gvt1.com/edgedl/release2/10/windows-8/googlechromestandaloneenterprise64.msi'
    checksum       = '9051f35bb709ff0e7323768ef4038d0986d8159e551bb5845bbff6ddbf994fcb'
    checksum64     = 'cafe689f31dda22a673b4c4357b2584e55067818c90f0069a2574b7006664032'
    checksumType   = 'sha256'
    checksumType64 = 'sha256'
    silentArgs     = "/quiet /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
    validExitCodes = @(0)
}

if (Get-Chrome32bitInstalled) { 'url64bit', 'checksum64', 'checksumType64' | ForEach-Object { $packageArgs.Remove($_) } }
Install-ChocolateyPackage @packageArgs
