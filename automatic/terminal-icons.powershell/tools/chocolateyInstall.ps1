$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = 'terminal-icons'  # this may be different from the package name and different case
$moduleVersion = $env:ChocolateyPackageVersion      # this may change so keep this here
$minPowerShellVersion = 4   # minimum PowerShell version required
$savedParamsPath = Join-Path $toolsDir -ChildPath 'parameters.saved'

if ($PSVersionTable.PSVersion.Major -lt $minPowerShellVersion) {
    throw "$moduleName module requires a minimum of PowerShell v$minPowerShellVersion."
}

function Copy-Module {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateScript( { Test-Path $_ })]
        [string]
        $Source,

        [Parameter(Mandatory)]
        [string]
        $Destination
    )

    if (-not (Test-Path -Path $Destination)) {
        Write-Verbose "Creating destination directory '$Destination' for module."
        New-Item -Path $Destination -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }

    Write-Verbose "Copying '$($script:moduleName)' files from '$Source' to '$Destination'."
    Copy-Item -Path $Source -Destination $Destination -Force -Recurse
}

# module may already be installed outside of Chocolatey
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

# remove the saved parameters file if it exists
if (Test-Path -Path $savedParamsPath) {
    Remove-Item -Path $savedParamsPath -Force
}

$params = Get-PackageParameters

# install the module to the correct folder depending on parameters
# by default, if no parameters, we install for Windows PowerShell (ie. Desktop)
if ($params.Desktop -or (-not $params.Core)) {
    $sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename\*"
    $destPath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName"

    Write-Verbose "Installing '$modulename' for Windows PowerShell (Desktop)."

    if ($PSVersionTable.PSVersion.Major -ge 5) {
        $destPath = Join-Path -Path $destPath -ChildPath $moduleVersion
    }

    Copy-Module -Source $sourcePath -Destination $destPath
    Add-Content -Path $savedParamsPath -Value 'Desktop'

    if ($PSVersionTable.PSVersion.Major -lt 4) {
        $modulePaths = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine') -split ';'
        if ($modulePaths -notcontains $destPath) {
            Write-Verbose "Adding '$destPath' to PSModulePath."
            $newModulePath = @($destPath, $modulePaths) -join ';'

            [Environment]::SetEnvironmentVariable('PSModulePath', $newModulePath, 'Machine')
            $env:PSModulePath = $newModulePath
        }
    }
}

if ($params.Core) {
    $sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename\*"
    $destPath = Join-Path -Path $env:ProgramFiles -ChildPath "PowerShell\Modules\$moduleName\$moduleVersion"

    Write-Verbose "Installing '$modulename' for PowerShell Core)."

    Copy-Module -Source $sourcePath -Destination $destPath
    Add-Content -Path $savedParamsPath -Value 'Core'
}

# cleanup the module from the Chocolatey $toolsDir folder
Remove-Item -Path $sourcePath -Force -Recurse