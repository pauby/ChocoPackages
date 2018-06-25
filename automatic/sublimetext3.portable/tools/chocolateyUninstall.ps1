$ErrorActionPreference = 'Stop'

[Environment]::GetFolderPath('Programs'), [Environment]::GetFolderPath('CommonPrograms') | ForEach-Object {
    Remove-Item -Path (Join-Path -Path $_ -ChildPath 'Sublime Text 3 Portable.lnk') -ErrorAction SilentlyContinue
}