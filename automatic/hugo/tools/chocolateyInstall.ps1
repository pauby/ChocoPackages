$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$zipFile = 'hugo_0.103.1_windows-amd64.zip'
$filePath = Join-Path -Path $toolsDir -ChildPath $zipFile

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileFullPath64 = $filePath
    destination    = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
