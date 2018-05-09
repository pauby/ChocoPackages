
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://github.com//syncthing/syncthing/releases/download/v0.14.47/syncthing-windows-386-v0.14.47.zip'
    checksum       = '6fbc3a8e78b136e73a35f7d8614b65698d5d121f73c349649618443e272239c9'
    checksumType   = 'SHA256'
    url64          = 'https://github.com//syncthing/syncthing/releases/download/v0.14.47/syncthing-windows-amd64-v0.14.47.zip'
    checksum64     = 'f10edfcc13f9047535bf8677147beacd9afdf8c1750eec528d4b6625b75ddb0c'
    checksumType64 = 'SHA256'
    unzipLocation  = $toolsdir
}

Install-ChocolateyZipPackage @packageArgs
