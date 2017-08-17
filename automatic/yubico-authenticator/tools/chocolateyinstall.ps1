$ErrorActionPreference = 'Stop';

$packageName  = 'yubico-authenticator'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.1.4/yubioath-desktop-4.1.4-win.exe'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubico-authenticator*'
  fileType      = 'exe'
  silentArgs    = "/S" # NSIS 
  validExitCodes= @(0)
  url			      = $url
  checksum      = '3a3632b38623a6728e2cfe2797110a11c067a528f600822b7fa147d830cfca64'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
