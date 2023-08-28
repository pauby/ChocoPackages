$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$versPath = 'vim90'
$destDir = Join-Path -Path $toolsDir -ChildPath $versPath

Get-ChildItem -Path "$destDir\*.bat" | ForEach-Object {
    Uninstall-BinFile -Name $_.BaseName -Path $_
}

Uninstall-ChocolateyEnvironmentVariable -VariableName 'VIM' -VariableType 'User'
