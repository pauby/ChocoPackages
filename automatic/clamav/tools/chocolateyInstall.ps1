$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  url64bit       = ''
  checksum64     = ''
  checksumType64 = ''
  unzipLocation  = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
