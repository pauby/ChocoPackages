
$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  softwareName   = 'Wavebox'

  url64bit       = 'https://download.wavebox.app/beta/win/Install%20Wavebox%2010.107.15.3.exe'
  checksum64     = '5fcf48f3ddd59080775319dbd0397a524a07030957d1560b8911bde860ddf57c'
  checksumType64 = 'sha256'

  validExitCodes = @(0, 3010, 1641)
  silentArgs     = '--disable-progress --do-not-launch-chrome'
}

Install-ChocolateyPackage @packageArgs
