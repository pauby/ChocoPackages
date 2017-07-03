$ErrorActionPreference = 'Stop';

$packageName  = 'yubikey-manager'
$url          = 'https://github.com//Yubico/yubikey-manager-qt/releases/download/0.3.0/yubikey-manager-qt-0.3.0-win.exe'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubikey manager*'
  fileType      = 'exe'
  silentArgs    = "/S"
  
  validExitCodes= @(0)
  url           = $url
  checksum      = 'e584acf51e01d22f3032f0cb78c24f2001d7c47151f628028bc722ac513e6351'
  checksumType  = 'sha256'

  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 


