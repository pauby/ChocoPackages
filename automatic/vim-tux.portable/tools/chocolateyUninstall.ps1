$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$destDir = Join-Path -Path $toolsDir -ChildPath 'vim'

Get-ChildItem -Path "$destDir\*.bat" | ForEach-Object {
    Uninstall-BinFile -Name $_.BaseName -Path $_
}

Uninstall-ChocolateyEnvironmentVariable -VariableName 'VIM' -VariableType 'User'
