$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp = Get-PackageParameters

$config = "$toolsDir\package_install.config"
$target = $toolsDir

if ($pp["target"]) {
    $target = $pp["target"]
    $target | Out-File $config
}
elseif (Test-Path $config) {
    $configPath = Get-Content -Path $config
    Write-Host "configPath: $configPath"
    if ($configPath -And (Test-Path $configPath)) { $target = configPath }
}

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.39.1/KeePass-2.39.1.zip/download'
    checksum       = '9caa97a428d8fabdaef40dec0ff9cec12b26347c6caef369f4fec7f73961469e'
    checksumType   = 'sha256'
    UnzipLocation  = $target
}

Install-ChocolateyZipPackage @packageArgs

Set-Content -Path (Join-Path -Path $toolsDir -ChildPath "KeePass.exe.gui") -Value $null
