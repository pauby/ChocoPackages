$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'exe'
    silentArgs     = "/S"
    validExitCodes = @(0)
    url            = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.3.4/yubioath-desktop-4.3.4-win32.exe'
    checksum       = '6ff47d81252606d97c3784f19c98413c9f2cfff2de965f46dbee3e1475448229'
    checksumType   = 'sha256'
    url64          = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.3.4/yubioath-desktop-4.3.4-win64.exe'
    checksum64     = '0d4f6fc254051f5c4b74a67fbfb974431328accd0ca8c1ca58669021d4292934'
    checksumType64 = 'sha256'
}

Install-ChocolateyPackage @packageArgs 
