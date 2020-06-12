$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    url           = 'https://bitbucket.org/ligos/readablepassphrasegenerator/downloads/ReadablePassphrase%201.1.1.plgx'
    checksum      = '34d634250b38ba6fb9f9537e41d2ba8ee668d10b4ce3fcae2ec36d68bd68f701'
    checksumType  = 'SHA256'
}

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

$oldPackageVersion = Join-Path -Path $installPath -ChildPath 'ReadablePassphrase*.plgx'
if (Test-Path $oldPackageVersion) {
    Write-Verbose 'Found old versions of this plugin. Removing.'
    $oldPackageVersion | Remove-Item -ErrorAction SilentlyContinue
}

$pluginFilename = 'ReadablePassphrase.plgx'
$pluginPath = Join-Path -Path $installPath -ChildPath 'Plugins'
$packageArgs.FileFullPath = Join-Path -Path $pluginPath -ChildPath $pluginFilename
Get-ChocolateyWebFile @packageArgs

if (Get-Process -Name 'KeePass' -ErrorAction SilentlyContinue) {
    Write-Warning "Keepass is currently running. '$($packageArgs.packageName)' will be available at next restart."
}
else {
    Write-Host "'$($packageArgs.packageName)' will be loaded the next time KeePass is started."
}
