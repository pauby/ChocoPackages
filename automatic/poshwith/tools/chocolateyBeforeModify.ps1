$ErrorActionPreference = 'Stop'

$moduleName = 'posh-with'      # this could be different from package name
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue