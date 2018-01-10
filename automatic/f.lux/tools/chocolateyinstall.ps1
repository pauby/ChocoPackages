$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://justgetflux.com/flux-setup.exe'
    checksum       = '0AC6369CA974E45270F98172327F516E1E8DC0E493EC62DC4DF2496F8A8C2523'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
