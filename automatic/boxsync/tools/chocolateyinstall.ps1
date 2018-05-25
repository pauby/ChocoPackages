$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/BoxSyncSetup.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'boxsync*'

  checksum      = 'f8f6f5ccc6b4263ea89b3527da741b748504abe5fe4e1c19366c9acd025c4086'
  checksumType  = 'SHA256'

  silentArgs    = '/install /quiet /norestart'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
