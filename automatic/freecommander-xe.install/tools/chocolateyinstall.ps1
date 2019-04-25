$ErrorActionPreference = 'Stop'

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://freecommander.com/downloads/FreeCommanderXE-32-public_setup.zip'
$setupName  = 'FreeCommanderXE-32-public_setup.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'FreeCommander XE*'
  checksum      = 'D92E0DC33094F0DAD293D560DC95A1293B4CE025B2CC1F93D435535BA919D017'
  checksumType  = 'SHA256' #default is md5, can also be sha1, sha256 or sha512
  silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs.file = Join-Path -Path $toolsDir -ChildPath $setupName
Install-ChocolateyInstallPackage @packageArgs
