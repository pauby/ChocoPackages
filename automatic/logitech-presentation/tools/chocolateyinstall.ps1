$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://download01.logi.com/web/ftp/pub/techsupport/presentation/LogiPresentation_1.50.340.exe'
    checksum       = '8c7ee86c8c2dbf11d96250a249a1b5f3dcf3f8e719fad310b9fa4987f780f11e'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = '/s'
    validExitCodes = @(0)   
}

Install-ChocolateyPackage @packageArgs
