$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

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

# old plugin version renamed the plugin - see https://github.com/dtgm/chocolatey-packages/pull/462
$oldPlugin = Join-Path -Path $installPath -ChildPath 'Plugins\keepass-plugin-keeautoexec*'
if (Test-Path -Path $oldPlugin) {
    try {
        Remove-Item -Path $oldPlugin -Force
        Write-Host "Old version of this plugin, with incorrect name, was deleted at '$oldPlugin'."
    }
    catch {
        Write-Warning "Old versions of this package, with incorrect name was found at '$oldPlugin'. However we were unable to delete it. Please do this manually or you risk Keepass not working correctly!"
    }
}

$packageArgs = @{
    FileFullPath = Join-Path -Path $toolsDir -ChildPath ("{0}.zip" -f $env:ChocolateyPackageName)
    Destination  = Join-Path -Path $installPath -ChildPath 'Plugins'
}
Get-ChocolateyUnzip @packageArgs

if (Get-Process -Name 'KeePass' -ErrorAction SilentlyContinue) {
    Write-Warning ("Keepass is currently running. '{0}' will be available at next restart." -f $env:ChocolateyPackageName)
}
else {
    Write-Host ("'{0}' will be loaded the next time KeePass is started." -f $env:ChocolateyPackageName)
}