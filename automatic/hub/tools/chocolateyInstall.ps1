$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    url            = 'https://github.com/github/hub/releases/download/v2.5.1/hub-windows-386-2.5.1.zip'
    checksum       = ''
    checksumType   = ''
    url64          = 'https://github.com/github/hub/releases/download/v2.5.1/hub-windows-amd64-2.5.1.zip'
    checksum64     = '7c2f7b53f5fb2eec8c1ac14ad52989b2810332c4558b960852e3f7ed20e351f8'
    checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
