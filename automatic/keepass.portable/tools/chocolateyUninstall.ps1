$ErrorActionPreference = 'Stop'

$installDir = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName

Uninstall-BinFile -Name 'keepass'
Remove-Item -Path $installDir -Recurse -Force