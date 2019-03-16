$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'exe'
    silentArgs     = "/S"
    
    validExitCodes = @(0)
    url            = 'https://developers.yubico.com/yubikey-manager-qt/Releases/yubikey-manager-qt-1.1.0-win32.exe'
    checksum       = 'c84bc170b5e9bc4979aac242d19b80fa2b8f5587a540dcc7233ee2aafacc77f5'
    checksumType   = 'sha256'
    url64          = 'https://developers.yubico.com/yubikey-manager-qt/Releases/yubikey-manager-qt-1.1.0-win64.exe'
    checksum64     = '1161de1953b1f5cd98be28b3117fb9972bfec08e1548cc5c08633c05b7f434ce'
    checksumType64 = 'sha256'
}

Install-ChocolateyPackage @packageArgs 


