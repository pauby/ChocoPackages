$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zipFolder  = 'KeeChallenge_1.5'

# find Keepass installation folder
$packageSearch = 'KeePass Password Safe*'
$installPath = ""

Write-Verbose "Searching for Keepass install location."
if ([array]$key = Get-UninstallRegistryKey -SoftwareName $packageSearch) {
    $installPath = $key.InstallLocation
}

if ([string]::IsNullOrEmpty($installPath)) {
    Write-Verbose "Searching $env:ChocolateyBinRoot for portable install..."
    $portPath = Join-Path -Path $toolsDir -ChildPath "keepass"
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

Write-Verbose "Deleting package files from Keepass at $installPath"
$sourcePath = Join-Path -Path $toolsDir -ChildPath $zipFolder
Get-ChildItem -Path $sourcePath -Recurse | ForEach {
    Remove-Item -Path $_.FullName.Replace($sourcePath, $installPath) -Recurse -ErrorAction SilentlyContinue
}