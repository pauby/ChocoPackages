$ErrorActionPreference = 'Stop';

$packageName  = 'yubico-authenticator'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.3.2/yubioath-desktop-4.3.2-win.exe'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubico-authenticator*'
  fileType      = 'exe'
  silentArgs    = "/S" # NSIS 
  validExitCodes= @(0)
  url			      = $url
  checksum      = 'c894808a341fafc176476c045bc1e26b5b878e194624c33e1a6b24382a353dc5'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
