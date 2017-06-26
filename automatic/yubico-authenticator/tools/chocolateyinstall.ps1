$ErrorActionPreference = 'Stop';

$packageName  = 'yubico-authenticator'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.1.2/yubioath-desktop-4.1.2-win.exe'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubico-authenticator*'
  fileType      = 'exe'
  silentArgs    = "/S" # NSIS 
  validExitCodes= @(0)
  url			      = $url
  checksum      = '5101aedb7d0000c4cca91bce878c6900453cd40a42151bccd4c2de2a4cf97f14'
  checksumType  = 'SHA256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
