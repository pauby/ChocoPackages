$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zip32Filename = ''
$zip64Filename = ''

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileFullPath    = Join-Path -Path $toolsdir -ChildPath $zip32Filename
    fileFullPath64  = Join-Path -Path $toolsdir -ChildPath $zip64Filename
    Destination     = $toolsDir
}

# remove the old folder(s) first
Get-Item -Path (Join-Path -Path $toolsDir -ChildPath 'syncthing-windows-*') | Where-Object PSIsContainer -eq $true | Remove-Item -Recurse -Force

Get-ChocolateyUnzip @packageArgs

# clean up embedded zips
Remove-Item -Path (Join-Path -Path $toolsDir -ChildPath 'syncthing-windows-*.zip') -Force