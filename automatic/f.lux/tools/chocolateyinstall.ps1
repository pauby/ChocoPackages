$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://justgetflux.com/flux-setup.exe'
    checksum       = 'F4374B532B5DD3DCCDD29EF8EB39EA19FB866819FA59326036BE876BCCFACAC9'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
