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
  checksum      = '4633a1a08d80ba2ef9cc16c9b4007664670637bfe09001b4ce7fa505986485ae'
  checksumType  = 'sha256'

  silentArgs    = "/silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
