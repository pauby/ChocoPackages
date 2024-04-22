$ErrorActionPreference = 'Stop'

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://freecommander.com/downloads/FreeCommanderXE-32-public_setup.zip'
$setupName  = 'FreeCommanderXE-32-public_setup.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'FreeCommander XE*'
  checksum      = 'FD19C5606A253975504B00FB9FBCC8134B0CB01409E7DAA81D6E3CDEF41E8434'
  checksumType  = 'SHA256' #default is md5, can also be sha1, sha256 or sha512
  silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs.file = Join-Path -Path $toolsDir -ChildPath $setupName
Install-ChocolateyInstallPackage @packageArgs
