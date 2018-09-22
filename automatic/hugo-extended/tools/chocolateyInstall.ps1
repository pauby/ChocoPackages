$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    url64          = 'https://github.com//gohugoio/hugo/releases/download/v0.48/hugo_extended_0.48_Windows-64bit.zip'

    checksum64     = '3c0e95ec66dc21e8e6a9b4ea8a8d12602914b2af2d44cccc8ddba4af6a656937'
    checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
