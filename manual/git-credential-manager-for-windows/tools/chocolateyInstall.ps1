
$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://github.com//Microsoft/Git-Credential-Manager-for-Windows/releases/download/v1.17.2/gcmw-1.17.2.exe'
    checksum       = '4B4FD3490F1514BFA4482914D1C3162F62B9FE04AE70119C378A887E1BE95604'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = '/SILENT /NORESTART'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
