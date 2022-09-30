$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zipFile  = 'hugo_extended_0.103.1_windows-amd64.zip'
$filePath = Join-Path -Path $toolsDir -ChildPath $zipFile

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileFullPath64 = $filePath
    destination    = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
