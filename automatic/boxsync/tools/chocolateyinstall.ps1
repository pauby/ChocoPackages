$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/BoxSyncSetup.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'boxsync*'

  checksum      = '7f0460e946c162911d90e49a5e770dffcfb746be6dad713d9debfc2bbe5b7e9e'
  checksumType  = 'SHA256'

  silentArgs    = '/install /quiet /norestart'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
