$ErrorActionPreference = 'Stop';

$packageName  = 'yubico-authenticator'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = ''

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubico-authenticator*'
  fileType      = 'exe'
  silentArgs    = "/S" # NSIS 
  validExitCodes= @(0)
  url           = "https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-3.1.0-win.exe"
  checksum      = '6340CA6BD1F059FAE2234A342834A977FF49BC64E4F8B0CDE33ABC062333A925'
  checksumType  = 'sha256'
  url64bit      = ""  
  checksum64    = ''
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
