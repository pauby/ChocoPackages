$ErrorActionPreference = 'Stop'

$moduleName = 'dbatools.library'      # this could be different from package name

$module = Get-Module -Name $moduleName
if ($module) {
    Write-Verbose "Module '$moduleName' is imported into the session. Removing it."
    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

    if ($lib = [appdomain]::CurrentDomain.GetAssemblies() | Where-Object FullName -like "dbatools, *") {
        Write-Verbose "Found locked DLL files for module '$moduleName'."
        $moduleDir = Split-Path $module.Path -Parent
        if ($lib.Location -like "$moduleDir\*") {
            Write-Warning @"
We have detected dbatools to be already imported from '$moduleDir' and the dll files have been locked and cannot be updated.
Please close all consoles that have dbatools imported (Remove-Module dbatools is NOT enough).
"@
            throw 
        }
    }
}