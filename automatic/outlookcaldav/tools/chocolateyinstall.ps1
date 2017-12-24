$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


$packageName  = 'outlookcaldav'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//aluxnimm/outlookcaldavsynchronizer/releases/download/v2.27.0/OutlookCalDavSynchronizer-2.27.0.zip'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  file			    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\CalDavSynchronizer.Setup.msi"

  softwareName  = 'OutlookCalDavSynchronizer*'

  checksum      = '09273fcf0dd63f629ed19c52fd63eb29f68d8fda31ee18711bdc61b9895bbb68'
  checksumType  = 'SHA256'

  silentArgs    = "/quiet"
  validExitCodes= @(0, 3010, 1641)
}


Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs
