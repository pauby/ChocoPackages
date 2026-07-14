$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://download01.logi.com/web/ftp/pub/techsupport/presentation/LogiPresentation_2.10.34.exe'
    checksum       = '683675924D28C8F14C59A898845981321A293A27EFB7EF8043F6551EA2F8D20D'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = '/s'
    validExitCodes = @(0)   
}

Install-ChocolateyPackage @packageArgs
