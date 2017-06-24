$ErrorActionPreference = 'Stop';

$packageName= 'keepass-plugin-keechallenge'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zipFolder  = 'KeeChallenge_1.5'
$url        = 'https://github.com/brush701/keechallenge/releases/download/1.5/KeeChallenge_1.5.zip'
$url64      = ''

$packageSearch = 'KeePass Password Safe*'
$installPath = ""

Write-Verbose "Searching for Keepass install location."
if ([array]$key = Get-UninstallRegistryKey -SoftwareName $packageSearch) {
    $installPath = $key.InstallLocation
}

if ([string]::IsNullOrEmpty($installPath)) {
    Write-Verbose "Searching $env:ChocolateyBinRoot for portable install..."
    $portPath = Join-Path -Path $$toolsDir -ChildPath "keepass"
    $installPath = Get-ChildItem -Directory $portPath* -ErrorAction SilentlyContinue
}

if ([string]::IsNullOrEmpty($installPath)) {
  Write-Verbose "Searching $env:Path for unregistered install..."
  $installFullName = (Get-Command keepass -ErrorAction SilentlyContinue).Path
  if (!$installFullName) {
      $installPath = Split-Path $installFullName -Parent
  }
}

if ([string]::IsNullOrEmpty($installPath)) {
  throw "$($packageSearch) not found."
}
else {
    Write-Verbose "Found Keepass install location at $installPath"
}

$packageArgs = @{
    packageName     = $packageName
    unzipLocation   = $toolsDir
    url             = $url
    url64bit        = $url64
    checksum        = '7A691E37858BEE3A69BA81ED1C7CE6DD42DE4096DFE9CD7B7547566399D3F369'
    checksumType    = 'sha256'
    checksum64      = ''
    checksumType64  = 'sha256'
}

Write-Verbose "Downloading and extracting plugin into Keepass folder at $keepassInstallPath"
Install-ChocolateyZipPackage @packageArgs

# copy the items from the chocolatey install folder to the Keepass install location
$sourcePath = Join-Path -Path $toolsDir -ChildPath $zipFolder
Get-ChildItem -Path $sourcePath -Recurse | ForEach {
    Copy-Item -Path $_.FullName -Destination ($_.FullName.Replace($sourcePath, $installPath)) -Force -ErrorAction SilentlyContinue
}

if ( Get-Process -Name "KeePass" -ErrorAction SilentlyContinue ) {
    Write-Warning "$($packageSearch) is currently running. Plugin will be available at next restart of $($packageSearch)."
}
else {
    Write-Host "$($packageName) will be loaded the next time KeePass is started."
}