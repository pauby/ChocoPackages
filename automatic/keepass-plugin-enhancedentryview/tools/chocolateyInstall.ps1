$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    url           = 'https://sourceforge.net/projects/kpenhentryview/files/v2.0/KPEnhancedEntryView-v2.0.zip/download'
    checksum      = '3c4583c64d3f57c077e68e9d3b47381b3db75d5b7e1e82c77ec801a62a76a744'
    checksumType  = 'sha256'
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

$packageArgs.unzipLocation = Join-Path -Path $installPath -ChildPath 'Plugins'

Install-ChocolateyZipPackage @packageArgs

if (Get-Process -Name 'KeePass' -ErrorAction SilentlyContinue) {
    Write-Warning "Keepass is currently running. '$($packageArgs.packageName)' will be available at next restart."
}
else {
    Write-Host "'$($packageArgs.packageName)' will be loaded the next time KeePass is started."
}
