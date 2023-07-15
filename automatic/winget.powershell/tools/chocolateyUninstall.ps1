$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
. $(Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)-helpers.ps1")

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