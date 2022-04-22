$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileFullPath    = Get-Item -Path "$toolsdir\syncthing-windows-386-v*_x32.zip"
    fileFullPath64  = Get-Item -Path "$toolsdir\syncthing-windows-amd64-v*_x64.zip"
    Destination     = $toolsDir
}

# remove the old folder(s) first
Get-Item -Path (Join-Path -Path $toolsDir -ChildPath 'syncthing-windows-*') | Where-Object PSIsContainer -eq $true | Remove-Item -Recurse -Force

Get-ChocolateyUnzip @packageArgs

# clean up embedded zips
Remove-Item -Path (Join-Path -Path $toolsDir -ChildPath 'syncthing-windows-*.zip') -Force