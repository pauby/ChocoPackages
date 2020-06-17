$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$pluginFilename = 'KeeTrayTOTP.plgx'
$pluginSourcePath = Join-Path -Path $toolsDir -ChildPath $pluginFilename

$packageSearch = 'KeePass Password Safe*'
$installPath = ''

Write-Verbose "Searching for Keepass install location."
if ([array]$key = Get-UninstallRegistryKey -SoftwareName $packageSearch) {
    $installPath = $key.InstallLocation
}

if ([string]::IsNullOrEmpty($installPath)) {
    Write-Verbose "Searching '$env:ChocolateyBinRoot' for portable install..."
    $portPath = Join-Path -Path $env:ChocolateyBinRoot -ChildPath "keepass"
    $installPath = Get-ChildItem -Directory "$portPath*" -ErrorAction SilentlyContinue
}

if ([string]::IsNullOrEmpty($installPath)) {
    Write-Verbose "Searching '$env:Path' for unregistered install..."
    $installFullName = Get-Command -Name keepass -ErrorAction SilentlyContinue
    if ($installFullName) {
        $installPath = Split-Path $installFullName.Path -Parent
    }
}

if ([string]::IsNullOrEmpty($installPath)) {
    throw "$($packageSearch) not found."
}
else {
    Write-Verbose "Found Keepass install location at '$installPath'."
}

$pluginDestinationPath = Join-Path (Join-Path -Path $installPath -ChildPath 'Plugins') -ChildPath $pluginFilename
Copy-Item -Path $pluginSourcePath -Destination $pluginDestinationPath -Force

if (Get-Process -Name 'KeePass' -ErrorAction SilentlyContinue) {
    Write-Warning "Keepass is currently running. '$($env:ChocolateyPackageName)' will be available at next restart."
}
else {
    Write-Host "'$($env:ChocolateyPackageName)' will be loaded the next time KeePass is started."
}
