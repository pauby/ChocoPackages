$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'MSI'
    url            = 'https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-5.0.2-win32.msi'
    checksum       = 'dcd575305d372dbe13efd01c327f6ba9968a21bac56fff62d773f75c0dc23681'
    checksumType   = 'sha256'
    url64          = 'https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-5.0.2-win64.msi'
    checksum64     = '59ef8ed435f8ba80baec56c7f78f4ff137a3d1bbc242617e6f17be897afd09ff'
    checksumType64 = 'sha256'
    silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
    validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 
