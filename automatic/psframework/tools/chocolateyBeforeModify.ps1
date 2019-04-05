$ErrorActionPreference = 'Stop'

$moduleName = 'psframework'      # this could be different from package name

$module = Get-Module -Name $moduleName
if ($module) {
    Write-Verbose "Module '$moduleName' is imported into the session. Removing it."
    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

    if ($lib = [appdomain]::CurrentDomain.GetAssemblies() | Where-Object FullName -like "psframework, *") {
        Write-Verbose "Found locked DLL files for module '$moduleName'."
        $moduleDir = Split-Path $module.Path -Parent
        if ($lib.Location -like "$moduleDir\*") {
            Write-Warning @"
We have detected '$moduleName' to be already imported from '$moduleDir' and the dll files have been locked and cannot be updated.
Please close all consoles that have the module imported (Remove-Module '$moduleName' is NOT enough).
"@
            throw
        }
    }
}