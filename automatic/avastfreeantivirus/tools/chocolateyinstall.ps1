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
  checksum      = '26aac5e38d5d5aa9287175786a7bb95e2606cfcc9630050bfe44d605757baf12'
  checksumType  = 'sha256'

  silentArgs    = "/silent"
  validExitCodes= @(0)
}

Write-Debug "OS Name: $($env:OS_NAME)"
if ($env:OS_NAME -like "*Server*") {
  throw "Cannot be installed on a Server operating system ($($env:OS_NAME))."
}

Install-ChocolateyPackage @packageArgs
