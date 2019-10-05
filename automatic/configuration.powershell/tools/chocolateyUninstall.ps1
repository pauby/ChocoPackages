$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = 'configuration'  # this may be different from the package name and different case
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

# remove path of module from $env:PSModulePath
if ($PSVersionTable.PSVersion.Major -lt 4) {
    $modulePaths = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine') -split ';'

    Write-Verbose "Removing '$sourcePath' from PSModulePath."
    $newModulePath = $modulePaths | Where-Object { $_ -ne $sourcePath }

    [Environment]::SetEnvironmentVariable('PSModulePath', $newModulePath, 'Machine')
    $env:PSModulePath = $newModulePath
}