$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'http://www.e7z.org/easy7zip_x86_x64.exe'
    checksum       = '9e3db79a5430c867fa7221147245655c84bb371ce18106181905ae5a9e6a6c80'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/VERYSILENT'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

