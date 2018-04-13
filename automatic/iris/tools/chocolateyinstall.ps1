$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://raw.githubusercontent.com/danielng01/Iris-Builds/master/Windows/Iris-0.9.5.8.exe'
    checksum       = '2f9739dc0957745a998458517814eba91b84cadf2a235be5b5dcfd6d0fe6e1ac'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
