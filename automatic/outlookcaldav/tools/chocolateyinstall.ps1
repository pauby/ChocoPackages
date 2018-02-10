$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


$packageName  = 'outlookcaldav'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//aluxnimm/outlookcaldavsynchronizer/releases/download/v3.0.0/OutlookCalDavSynchronizer-3.0.0.zip'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  file			    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\CalDavSynchronizer.Setup.msi"

  softwareName  = 'OutlookCalDavSynchronizer*'

  checksum      = 'c114c904ede88f91e3937c42fe613d7b5523285da1a7933d73c31e3b5c963c7d'
  checksumType  = 'SHA256'

  silentArgs    = "/quiet"
  validExitCodes= @(0, 3010, 1641)
}


Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs
