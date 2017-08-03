$ErrorActionPreference = 'Stop';

$packageName  = 'yubico-authenticator'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.1.3/yubioath-desktop-4.1.3-win.exe'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubico-authenticator*'
  fileType      = 'exe'
  silentArgs    = "/S" # NSIS 
  validExitCodes= @(0)
  url			      = $url
  checksum      = 'efdf6301f4a97ef66d72f7d3957f3cdd543e28d06e2b13e26f64dfafc660bf01'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
