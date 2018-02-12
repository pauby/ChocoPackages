$ErrorActionPreference = 'Stop';

$packageName= 'avastfreeantivirus'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://files.avast.com/iavs9x/avast_free_antivirus_setup_online.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Avast Free Antivirus'
  checksum      = 'cfd0162028576b4fc580101e38494e34e25a20c25c8d4e7a3ed4eaf2de92a035'
  checksumType  = 'sha256'

  silentArgs    = "/silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
