$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = 'configuration' # this may be different from the package name and different case
$moduleVersion = $env:ChocolateyPackageVersion  # this may change so keep this here
$savedParamsPath = Join-Path $toolsDir -ChildPath 'parameters.saved'
$minPSVersion = 2

if ($PSVersionTable.PSVersion.Major -lt $minPSVersion) {
    throw "$moduleName module requires a minimum of PowerShell v$minPSVersion."
}

# module may already be installed outside of Chocolatey
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

# remove the saved parameters file if it exists
if (Test-Path -Path $savedParamsPath) {
    Remove-Item -Path $savedParamsPath -Force
}

$params = Get-PackageParameters

$sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename.zip"
$destinationPath = @()
if ($params.Desktop -or (-not $params.Core)) {
    $desktopPath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName"

    # PS > 5 needs to extract to a folder with the module version
    if ($PSVersionTable.PSVersion.Major -ge 5) {
        $desktopPath = Join-Path -Path $desktopPath -ChildPath $moduleVersion
    }

    $destinationPath += $desktopPath
}

if ($params.Core) {
    $destinationPath += Join-Path -Path $env:ProgramFiles -ChildPath "PowerShell\Modules\$moduleName\$moduleVersion"
}

ForEach ($destPath in $destinationPath) {
    Write-Verbose "Installing '$modulename' to '$destPath'."

    # check destination path exists and create if not
    if (Test-Path -Path $destPath) {
        $null = New-Item -Path $destPath -ItemType Directory -Force
    }
    Get-ChocolateyUnzip -FileFullPath $sourcePath -Destination $destPath -PackageName $moduleName

    # save the locations where the module was installed so we can uninstall it
    Add-Content -Path $savedParamsPath -Value $destPath
}

# For PowerShell 4 the module destination needs to be added to the PSModulePath
if ($PSVersionTable.PSVersion.Major -lt 4) {
    $modulePaths = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine') -split ';'
    if ($modulePaths -notcontains $destPath) {
        Write-Verbose "Adding '$destPath' to PSModulePath."
        $newModulePath = @($destPath, $modulePaths) -join ';'

        [Environment]::SetEnvironmentVariable('PSModulePath', $newModulePath, 'Machine')
        $env:PSModulePath = $newModulePath
    }
}

# cleanup the module from the Chocolatey $toolsDir folder
Remove-Item -Path $sourcePath -Force -Recurse