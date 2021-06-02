$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = 'https://s3browser.com//download/s3browser-9-5-5.exe'
    checksum       = '108abd78a9bdf7817b1c5f012e1111ad53db2f9000516dc7f7405677ac66f78b'
    checksumType   = 'sha256'

    silentArgs     = '/VERYSILENT /NORESTART'
    validExitCodes = $(0)
}

Install-ChocolateyPackage @packageArgs 
