$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'exe'
    silentArgs     = "/S"
    validExitCodes = @(0)
    url            = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.3.4/yubioath-desktop-4.3.4-win32.exe'
    checksum       = ''
    checksumType   = ''
    url64          = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.3.4/yubioath-desktop-4.3.4-win64.exe'
    checksum64     = ''
    checksumType64 = ''
}

Install-ChocolateyPackage @packageArgs 
