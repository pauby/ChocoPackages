$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/BoxSyncSetup.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'boxsync*'

  checksum      = 'e40c7fe5c24fe2b167833bfc9bd51e0738a500674109c738c9eea7c9ee3588e5'
  checksumType  = 'SHA256'

  silentArgs    = '/install /quiet /norestart'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
