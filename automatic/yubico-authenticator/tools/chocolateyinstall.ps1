$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    fileType      = 'exe'
    silentArgs    = "/S"
    validExitCodes= @(0)
    url           = 'https://github.com//Yubico/yubioath-desktop/releases/download/yubioath-desktop-4.3.3/yubioath-desktop-4.3.3-win.exe'
    checksum      = '5a13fde898ab9f225cb164f737f8525e112250e95c0abed2cc87003bd3d468af'
    checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs 
