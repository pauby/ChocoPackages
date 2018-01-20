$ErrorActionPreference = 'Stop'

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://freecommander.com/downloads/FreeCommanderXE-32-public_740.msi'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url

  softwareName  = 'FreeCommander XE*'
  checksum      = 'd32925bfec61f14638403274a81471a8cefc299297317cee3a99d341b6bcf2a1'
  checksumType  = 'SHA256' #default is md5, can also be sha1, sha256 or sha512
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs