$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://raw.githubusercontent.com/danielng01/Iris-Builds/master/Windows/Iris-0.9.2.7.exe'
    checksum       = '77d2dc225195b8cf2a4017689c611553b32da2f0f2f20dec13a9771e98c07400'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
