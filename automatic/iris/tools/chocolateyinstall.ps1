$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://raw.githubusercontent.com/danielng01/Iris-Builds/master/Windows/Iris-0.9.4.exe'
    checksum       = '2e2347bb646e74f21643fc2dece0733a153cd6b8822510f7f9fa6b1c7b4c254d'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
