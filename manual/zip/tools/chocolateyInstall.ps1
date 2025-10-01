$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$filenamex86 = 'zip300xn.zip'
$filenamex64 = 'zip300xn-x64.zip'

$packageArgs = @{
  PackageName    = $env:ChocolateyPackageName
  FileFullPath   = Join-Path -Path $toolsDir -ChildPath $filenamex86
  FileFullPath64 = Join-Path -Path $toolsDir -ChildPath $filenamex64
  Destination    = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
