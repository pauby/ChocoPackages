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
  checksum      = 'c35ee21a6bdef43f03b0627e886132ca8305830216467d9e9e7a975efecd4fbb'
  checksumType  = 'sha256'

  silentArgs    = "/silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
