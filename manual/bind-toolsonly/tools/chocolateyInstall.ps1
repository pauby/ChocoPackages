$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition
$extractDir = Join-Path -Path $toolsDir -ChildPath 'content'

$packageArgs = @{
    packageName     = 'bind'
    fileFullPath64  = Join-Path -Path $toolsDir -ChildPath 'BIND9.16.28.x64.zip'
    destination     = $extractDir
}

Get-ChocolateyUnzip @packageArgs

Remove-Item -Path (Join-Path -Path $toolsDir -ChildPath 'BIND9.16.28.x64.zip') -Force