$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://download01.logi.com/web/ftp/pub/techsupport/presentation/LogiPresentation_1.40.104.exe'
    checksum       = ''
    checksumType   = ''
    fileType       = 'EXE'
    silentArgs     = '/s'
    validExitCodes = @(0)   
}

Install-ChocolateyPackage @packageArgs
