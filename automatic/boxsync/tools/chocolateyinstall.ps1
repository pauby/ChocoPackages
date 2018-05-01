$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/BoxSyncSetup.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'boxsync*'

  checksum      = 'fbe1585203d37bb3cd9ae63d9749478e8f3bf73c40fef07cfbdf657fb0cda4d7'
  checksumType  = 'SHA256'

  silentArgs    = '/install /quiet /norestart'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
