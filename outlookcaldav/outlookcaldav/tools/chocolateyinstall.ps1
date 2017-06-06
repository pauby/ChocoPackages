$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


$packageName  = 'outlookcaldav'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = "https://github.com/aluxnimm/outlookcaldavsynchronizer/releases/download/v$($env:ChocolateyPackageVersion)/OutlookCalDavSynchronizer-$($env:ChocolateyPackageVersion).zip"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  file			    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\CalDavSynchronizer.Setup.msi"

  softwareName  = 'OutlookCalDavSynchronizer*'

  checksum      = '9C2D36A7D7A9C57569E2084D61C546CC3265AD2D50A2ACF648EB6B3C0F5DD5EC'
  checksumType  = 'sha256'

  silentArgs    = "/quiet"
  validExitCodes= @(0, 3010, 1641)
}


Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs