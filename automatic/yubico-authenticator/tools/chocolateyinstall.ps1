$ErrorActionPreference = 'Stop';

$packageName  = 'yubico-authenticator'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.2.0/yubioath-desktop-4.2.0-win.exe'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubico-authenticator*'
  fileType      = 'exe'
  silentArgs    = "/S" # NSIS 
  validExitCodes= @(0)
  url			      = $url
  checksum      = '3756f9dc04e91306eee3f589f2e6cf9fd25d7dc5d3c89f9647af3a0d5b891aab'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
