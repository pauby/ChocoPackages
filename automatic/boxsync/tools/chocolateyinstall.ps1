$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/SyncMSI32.msi'
$url64          = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/SyncMSI64.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  url           = $url32
  checksum      = '5d233c74cbef37308e6b264d70946216d846936d804b55f06ca6e5ea3ec8c047'
  checksumType  = 'SHA256'

  url64         = $url64
  checksum64    = '6ba75e974821a85d5e11060f0651f5e69ccc13147cbc34508ced9d4c84b8ad6e'
  checksumType64= 'SHA256'

  softwareName  = 'boxsync*'

  silentArgs    = "/quiet /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
Write-Verbose "Boxsync install log file is available at '$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log'"
