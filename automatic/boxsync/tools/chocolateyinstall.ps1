$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/BoxSyncSetup.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'boxsync*'

  checksum      = '6baf6e1972ee704bbda53df08945b6cfc309274b589bc39a1030dd297eb6131f'
  checksumType  = 'SHA256'

  silentArgs    = '/install /quiet /norestart'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
