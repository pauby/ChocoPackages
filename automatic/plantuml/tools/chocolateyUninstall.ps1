$ErrorActionPreference = 'Stop'

Uninstall-BinFile 'plantuml'
Remove-Item -Path (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\plantuml.lnk" -ErrorAction SilentlyContinue)