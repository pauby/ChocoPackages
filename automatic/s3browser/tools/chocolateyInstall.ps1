$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = 'https://s3browser.com//download/s3browser-8-6-7.exe'
    checksum       = ''
    checksumType   = ''

    silentArgs     = '/VERYSILENT /NORESTART'
    validExitCodes = $(0)
}

Install-ChocolateyPackage @packageArgs 
