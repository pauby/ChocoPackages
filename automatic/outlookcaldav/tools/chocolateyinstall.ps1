$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


$packageName  = 'outlookcaldav'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//aluxnimm/outlookcaldavsynchronizer/releases/download/v2.25.0/OutlookCalDavSynchronizer-2.25.0.zip'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  file			    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\CalDavSynchronizer.Setup.msi"

  softwareName  = 'OutlookCalDavSynchronizer*'

  checksum      = '750ecfd3f75e2d4fe9eb4a7186bf0e4c78cbfabe3c8611d0bdcf99fb01f3ec26'
  checksumType  = 'SHA256'

  silentArgs    = "/quiet"
  validExitCodes= @(0, 3010, 1641)
}


Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs
