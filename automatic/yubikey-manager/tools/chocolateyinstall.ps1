$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'exe'
    silentArgs     = "/S"
    
    validExitCodes = @(0)
    url            = 'https://github.com//Yubico/yubikey-manager-qt/releases/download/yubikey-manager-qt-0.5.1/yubikey-manager-qt-0.5.1-win32.exe'
    checksum       = 'f7ed30a925f03539df8cf84c60587d8e9f1a567a58e24e0e3070623cb1980f97'
    checksumType   = 'sha256'
    url64          = 'https://github.com//Yubico/yubikey-manager-qt/releases/download/yubikey-manager-qt-0.5.1/yubikey-manager-qt-0.5.1-win64.exe'
    checksum64     = 'f074ac6e507824c02ee5a5e0acec6fee026348ca0253d6647b847de31f6411a0'
    checksumType64 = 'sha256'
}

Install-ChocolateyPackage @packageArgs 


