$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$file64Filename = 'clamav-1.1.0.win.x64.zip'

$packageArgs = @{
  packageName = $env:ChocolateyPackageName
  fileFullPath64 = Join-Path -Path $toolsDir -ChildPath $file64Filename
  destination = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
