$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = 'az'  # this may be different from the package name and different case
$savedParamsPath = Join-Path $toolsDir -ChildPath 'parameters.saved'
$depModulesPath = Join-Path $toolsdir -ChildPath 'dependent.modules'

if (Test-Path -Path $savedParamsPath) {
    $removePath = Get-Content -Path $savedParamsPath
}
else {
    $removePath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\"
}

ForEach ($path in $removePath) {
    if (-not (Test-Path -Path $depModulesPath)) {
        Write-Error "Cannot find the list of dependent modules to remove at '$depModulesPath'. Cannot uninstall."
    }

    Get-Content -Path $depModulesPath | ForEach-Object {
        $pathToRemove = Join-Path -Path $path -ChildPath $_
        Write-Verbose "Removing all version of '$_' from '$pathToRemove'."
        Remove-Item -Path $pathToRemove -Recurse -Force -ErrorAction SilentlyContinue
    }
}