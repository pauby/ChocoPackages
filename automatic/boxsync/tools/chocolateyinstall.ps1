$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/SyncMSI32.msi'
$url64          = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/SyncMSI64.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  url           = $url32
  checksum      = 'D3954C8473FD38DC8F40F90AF04270B03B81B1710A33E64F3B8A2310BC5C25FB'
  checksumType  = 'SHA256'

  url64         = $url64
  checksum64    = '3CB19C4271607A53BAC772BCB460CD366BF5C60BC447E87F30DC7C20A7838DCF'
  checksumType64= 'SHA256'

  softwareName  = 'boxsync*'

  silentArgs    = "/quiet /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
Write-Verbose "Boxsync install log file is available at '$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log'"
