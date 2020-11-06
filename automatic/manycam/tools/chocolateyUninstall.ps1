$ErrorActionPreference = 'Stop'

$startFolderPath = Join-Path -Path ([Environment]::GetFolderPath('StartMenu')) -ChildPath 'Programs\ManyCam'
if (Test-Path -Path $startFolderPath) {
    Remove-Item -Path $startFolderPath -Recurse -Force
}