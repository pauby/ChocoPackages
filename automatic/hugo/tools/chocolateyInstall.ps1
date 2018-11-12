$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    url            = 'https://github.com//gohugoio/hugo/releases/download/v0.51/hugo_0.51_Windows-32bit.zip'
    url64          = 'https://github.com//gohugoio/hugo/releases/download/v0.51/hugo_0.51_Windows-64bit.zip'

    checksum       = 'BB6AE1134F2772D77A257C81DF526518406429918D636E3A0CB05D853A1E486E'
    checksumType   = 'sha256'
    checksum64     = 'A2ECE21BD629481E88AAFAE413FB6DA23BE3F7967753E8F09CBE40A12EC14921'
    checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs