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
  checksum      = 'bc5ddca325b40c510a291cbe2e8adef4fb059b40f18e031d6416a43cb6cca2fe'
  checksumType  = 'sha256'

  silentArgs    = "/silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
