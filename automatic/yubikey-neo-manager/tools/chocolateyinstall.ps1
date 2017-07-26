$ErrorActionPreference = 'Stop';

$packageName  = 'yubikey-neo-manager'
$url          = 'https://developers.yubico.com/yubikey-neo-manager/Releases/yubikey-neo-manager-1.4.0-win.exe'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubikey-neo-manager*'
  fileType      = 'exe'
  silentArgs    = "/S"
  
  validExitCodes= @(0)
  url           = $url
  checksum      = 'D7D03379AF80AE15487106C685DCEACF1851D6D4D59BDE29117C42B9B83167E2'
  checksumType  = 'sha256'

  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
