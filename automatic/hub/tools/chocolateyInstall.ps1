$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    url            = 'https://github.com/github/hub/releases/download/v2.5.1/hub-windows-386-2.5.1.zip'
    checksum       = '1ad762624e570591394354ff92401bd1f33577caab9b141eb0c68f83f9a6b515'
    checksumType   = 'sha256'
    url64          = 'https://github.com/github/hub/releases/download/v2.5.1/hub-windows-amd64-2.5.1.zip'
    checksum64     = '7c2f7b53f5fb2eec8c1ac14ad52989b2810332c4558b960852e3f7ed20e351f8'
    checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
