$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://download01.logi.com/web/ftp/pub/techsupport/presentation/LogiPresentation_1.40.104.exe'
    checksum       = '6B124E23EC0416C2BAC3A5456CE5A659121174DE5B0BE6E2B5BB9A47F837D629'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = '/s'
    validExitCodes = @(0)   
}

Install-ChocolateyPackage @packageArgs
