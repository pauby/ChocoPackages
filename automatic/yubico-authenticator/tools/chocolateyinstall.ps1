$ErrorActionPreference = 'Stop';

$packageName  = 'yubico-authenticator'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.3.0/yubioath-desktop-4.3.0-win.exe'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubico-authenticator*'
  fileType      = 'exe'
  silentArgs    = "/S" # NSIS 
  validExitCodes= @(0)
  url			      = $url
  checksum      = 'fa68acc4674c15aa21789c6b75479a56953c7fb31182ace1a3777de1d1a13e14'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
