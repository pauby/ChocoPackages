
$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  url           = 'https://sourceforge.net/projects/googlesyncmod/files/Releases/3.10.14/SetupGCSM-3.10.14.msi'
  checksum      = '91C8B087A8AECDAA22101998326958D4AE4DC017A6DADD08155C5D5D0417F970'
  checksumType  = 'sha256'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs