$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = 'Microsoft.WinGet.Client' # this could be different from package name
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