
$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://github.com//Microsoft/Git-Credential-Manager-for-Windows/releases/download/v1.17.2/gcmw-v1.17.2.zip'
    checksum       = '0cc56ca28de8f9b4f35cf92a240b3709f9640de18094dd34fc9d2be196b4b30f'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = '/SILENT /NORESTART'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
