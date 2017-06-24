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

  checksum      = 'F289CE46B64495F37FC74FDBAE37DB370524458F7B25927C0AA93B5137D58D2B'
  checksumType  = 'sha256'

  silentArgs    = "/quiet"
  validExitCodes= @(0, 3010, 1641)
}


Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs