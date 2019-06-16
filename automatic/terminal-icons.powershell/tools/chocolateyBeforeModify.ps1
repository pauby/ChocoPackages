$ErrorActionPreference = 'Stop'

$moduleName = 'terminal-icons'      # this could be different from package name
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue