$ErrorActionPreference = 'Stop'

$moduleName = 'Jump.Location'      # this could be different from package name
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue