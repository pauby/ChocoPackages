$ErrorActionPreference = 'Stop'

$toolsLocation = Get-ToolsLocation
$installPath = Join-Path -Path $toolsLocation -ChildPath 'languagetool'
if (Test-Path -Path $installPath) {
    Remove-Item -Path $installPath -Recurse | Out-Null
}