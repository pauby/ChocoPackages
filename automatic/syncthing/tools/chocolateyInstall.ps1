
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileFullPath    = Get-Item -Path "$toolsdir\syncthing-windows-386-v*_x32.zip"
    fileFullPath64  = Get-Item -Path "$toolsdir\syncthing-windows-amd64-v*_x64.zip"
    Destination     = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
