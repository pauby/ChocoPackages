$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://raw.githubusercontent.com/danielng01/Iris-Builds/master/Windows/Iris-0.9.3.exe'
    checksum       = '5de0f205b5f5b49a856ffb9b7626b2e346ffb7998e234bbbecee9ed61826022d'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
