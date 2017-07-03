$ErrorActionPreference = 'Stop';

$packageName = 'yubikey-piv-manager'
$url = 'https://github.com//Yubico/yubikey-piv-manager/releases/download/yubikey-piv-manager-1.4.2/yubikey-piv-manager-1.4.2-win.exe'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $packageName
    softwareName   = 'yubikey piv manager*'
    fileType       = 'exe'
    silentArgs     = "/S"
  
    validExitCodes = @(0)
    url            = $url
    checksum       = 'fd6f3ef1497c065731f4c7dd270f99aebaba78ac63be71d62e8a9ec073b7de90'
    checksumType   = 'sha256'

    destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs 

# add start menu shortcuts
if (Get-OSArchitectureWidth -eq "64") {
    $targetPath = "C:\Program Files (x86)\Yubico\YubiKey PIV Manager"
}
else {
    $targetPath = "C:\Program Files\Yubico\YubiKey PIV Manager"
}

$menuPath = (Join-Path -Path $env:APPDATA -ChildPath "Microsoft\Windows\Start Menu\Programs\Yubico\Yubikey PIV Manager")

Install-ChocolateyShortcut `
    -ShortcutFilePath (Join-Path -Path $menuPath -ChildPath "Yubikey PIV Manager.lnk") `
    -TargetPath (Join-Path -Path $targetPath -ChildPath "pivman.exe")

Install-ChocolateyShortcut `
    -ShortcutFilePath (Join-Path -Path $menuPath -ChildPath "Uninstall PIV Manager.lnk") `
    -TargetPath (Join-Path -Path $targetPath -ChildPath "uninstall.exe")
