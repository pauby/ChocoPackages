$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    unzipLocation = (Join-Path -Path $toolsDir -ChildPath $env:ChocolateyPackageName)
    url           = 'https://wimlib.net/downloads/wimlib-1.12.0-windows-x86_64-bin.zip'
    checksum      = '0e866976a376bf3106e8a160d936b4cbfa832d4a1f23f7e1de1607df3e3d12bb'
    checksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @packageArgs

(Get-ChildItem -Path $packageArgs.unzipLocation -Filter '*.cmd').ForEach( {
    Install-BinFile -Name $_.BaseName -Path $_.FullName
} )