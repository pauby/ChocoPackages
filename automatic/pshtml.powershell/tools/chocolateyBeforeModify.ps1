$ErrorActionPreference = 'Stop'

$moduleName = 'pshtml'      # this could be different from package name
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue