$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileType     = 'exe'
  silentArgs   = "/S"

  url          = 'https://developers.yubico.com/yubikey-personalization-gui/Releases/yubikey-personalization-gui-3.1.25.exe'
  checksum     = '3debb239ff541ae6de058580cbecfc28137915f1118fd902de8e478c0d8168f2'
  checksumType = 'SHA256'
}

Install-ChocolateyPackage @packageArgs
