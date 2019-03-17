$ErrorActionPreference = 'Stop'

$installDir = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.39.1/KeePass-2.39.1.zip/download'
    checksum       = '9caa97a428d8fabdaef40dec0ff9cec12b26347c6caef369f4fec7f73961469e'
    checksumType   = 'sha256'
    UnzipLocation  = $installDir
}

Install-ChocolateyZipPackage @packageArgs
Install-BinFile -Name 'keepass' -Path (Join-Path -Path $installDir -ChildPath 'keepass.exe')