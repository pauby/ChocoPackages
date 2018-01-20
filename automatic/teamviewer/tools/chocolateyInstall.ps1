$ErrorActionPreference = 'Stop';

$packageName = 'teamviewer'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.teamviewer.com/download/TeamViewer_Setup.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'TeamViewer*'

  checksum      = 'B6451F173C7A0E0BF91C2DB865E1D3FA94516D2778AFAD5CF3137AA6A12912D1'
  checksumType  = 'sha256'

  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
