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
  checksum      = 'ed39749a3c77f24869bd8f3b07267d989e9db1fe1b561b227a8342c9556b2a83'
  checksumType  = 'SHA256' #default is md5, can also be sha1, sha256 or sha512
  silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs.file = Join-Path -Path $toolsDir -ChildPath $setupName
$packageArgs
Install-ChocolateyInstallPackage @packageArgs
