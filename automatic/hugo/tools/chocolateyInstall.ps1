$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    url64          = 'https://github.com//gohugoio/hugo/releases/download/v0.71.0/hugo_0.71.0_Windows-64bit.zip'

    checksum64     = 'b84abcc4fcd5b990dab8399198eedefdf5b560aad09ece7a25c1fd806d53b2a4'
    checksumType64 = 'SHA256'
}

Install-ChocolateyZipPackage @packageArgs
