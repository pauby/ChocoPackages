$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = 'Microsoft.WinGet.Client' # this could be different from package name
$moduleVersion = $env:ChocolateyPackageVersion  # this may change so keep this here
$savedParamsPath = Join-Path $toolsDir -ChildPath 'parameters.saved'
$minPSVersion = '5.1.0'

if ($PSVersionTable.PSVersion -lt [version]$minPSVersion) {
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
    $destinationPath += $desktopPath
}

if ($params.Core) {
    $destinationPath += Join-Path -Path $env:ProgramFiles -ChildPath "PowerShell\Modules\$moduleName"
}

ForEach ($destPath in $destinationPath) {
    Write-Verbose "Installing '$modulename' to '$destPath'."

    # PS > 5 needs the module version at the end
    $fullDestPath = (Join-Path -Path $destPath -ChildPath $moduleVersion)

    # check destination path exists and create if not
    if (Test-Path -Path $fullDestPath) {
        $null = New-Item -Path $fullDestPath -ItemType Directory -Force
    }

    Get-ChocolateyUnzip -FileFullPath $sourcePath -Destination $fullDestPath -PackageName $moduleName

    # save the locations where the module was installed so we can uninstall it
    Add-Content -Path $savedParamsPath -Value $destPath
}

# cleanup the module from the Chocolatey $toolsDir folder
Remove-Item -Path $sourcePath -Force -Recurse