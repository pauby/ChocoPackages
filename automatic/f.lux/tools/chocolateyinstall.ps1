$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://justgetflux.com/flux-setup.exe'
    checksum       = '79FC802D9225D98EE15A288393BB2D4708575315B9EDAD33DBFCF29D1AF578B1'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
