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
  url			= "https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-$($env:ChocolateyPackageVersion)-win.exe"
  checksum      = 'B71F9510A97FB52B9A70E35D98498D20A507AAC6968F1FC9E8CFF13EB5424218'
  checksumType  = 'sha256'
  url64bit      = ""  
  checksum64    = ''
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
