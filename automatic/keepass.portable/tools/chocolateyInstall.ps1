$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.39/KeePass-2.39.zip/download'
    checksum       = 'cf5efc6a4d6e3625e992765ad292bd86e73cc329c534f73d9788750bc3470c2d'
    checksumType   = 'sha256'
    UnzipLocation  = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

Set-Content -Path (Join-Path -Path $toolsDir -ChildPath "KeePass.exe.gui") -Value $null
