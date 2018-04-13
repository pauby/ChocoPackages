$ErrorActionPreference = 'Stop'

[Environment]::GetFolderPath('Programs'), [Environment]::GetFolderPath('CommonPrograms') | ForEach-Object {
    Remove-Item -Path (Join-Path -Path $_ -ChildPath 'f.lux.lnk') -ErrorAction SilentlyContinue
    Remove-Item -Path (Join-Path -Path $_ -ChildPath '\Startup\f.lux.lnk') -ErrorAction SilentlyContinue
}