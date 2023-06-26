$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://download01.logi.com/web/ftp/pub/techsupport/presentation/LogiPresentation_1.60.33.exe'
    checksum       = '13B6874B7A4FF76A77B38B76E20B6B353FC6DA0DB2FB4C868FC00AC9C3239570'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = '/s'
    validExitCodes = @(0)   
}

Install-ChocolateyPackage @packageArgs
