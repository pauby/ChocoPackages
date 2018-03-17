$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://raw.githubusercontent.com/danielng01/Iris-Builds/master/Windows/Iris-0.9.4.1.exe'
    checksum       = '25f17f6eb9b2dac992abf22e380d201be2ad10f3d62a08a1070c34f68a8b116a'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
