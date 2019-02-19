$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp = Get-PackageParameters


$installPath = $toolsDir

if ($pp["installPath"]) {
    $installPath = $pp["installPath"]
}

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.39.1/KeePass-2.39.1.zip/download'
    checksum       = '9caa97a428d8fabdaef40dec0ff9cec12b26347c6caef369f4fec7f73961469e'
    checksumType   = 'sha256'
    UnzipLocation  = $installPath
}

Install-ChocolateyZipPackage @packageArgs

Set-Content -Path (Join-Path -Path $installPath -ChildPath "KeePass.exe.gui") -Value $null
