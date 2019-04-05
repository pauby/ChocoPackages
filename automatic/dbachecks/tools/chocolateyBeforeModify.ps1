$ErrorActionPreference = 'Stop'

$moduleName = 'dbachecks'      # this could be different from package name

$module = Get-Module -Name $moduleName
if ($module) {
    Write-Verbose "Module '$moduleName' is imported into the session. Removing it."
    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
    }
}