$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.38/KeePass-2.38.zip/download'
    checksum       = 'db71cba72c321ecaeda7eec6f4e71e215864d4113ab9e29dc97ad4d56c80a7a9'
    checksumType   = 'sha256'
    UnzipLocation  = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

Set-Content -Path (Join-Path -Path $toolsDir -ChildPath "KeePass.exe.gui") -Value $null
