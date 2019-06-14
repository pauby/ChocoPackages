$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = $env:ChocolateyPackageName  # this may be different from the package name and different case
$savedParamsPath = Join-Path $toolsDir -ChildPath 'parameters.saved'

if (Test-Path -Path $savedParamsPath) {
    $uninstallEdition = Get-Content -Path $savedParamsPath
}
else {
    $uinstallEdition = 'Desktop'
}

ForEach ($edition in $uninstallEdition) {
    switch ($edition) {
        'Desktop' {
            $sourcePath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName"
            break
        }
        'Core' {
            $sourcePath = Join-Path -Path $env:ProgramFiles -ChildPath "PowerShell\Modules\$moduleName"
            break
        }
    }

    Write-Verbose "Removing all version of '$moduleName' from '$sourcePath'."
    Remove-Item -Path $sourcePath -Recurse -Force -ErrorAction SilentlyContinue
}

# remove path of module from $env:PSModulePath
if ($PSVersionTable.PSVersion.Major -lt 4) {
    $modulePaths = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine') -split ';'

    Write-Verbose "Removing '$sourcePath' from PSModulePath."
    $newModulePath = $modulePaths | Where-Object { $_ -ne $sourcePath }

[Environment]::SetEnvironmentVariable('PSModulePath', $newModulePath, 'Machine')
$env:PSModulePath = $newModulePath
}