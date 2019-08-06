$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = 'pshtml'  # this may be different from the package name and different case
$savedParamsPath = Join-Path $toolsDir -ChildPath 'parameters.saved'

if (Test-Path -Path $savedParamsPath) {
    $removePath = Get-Content -Path $savedParamsPath
}
else {
    $removePath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName"
}

ForEach ($path in $removePath) {
    Write-Verbose "Removing all version of '$moduleName' from '$path'."
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
}