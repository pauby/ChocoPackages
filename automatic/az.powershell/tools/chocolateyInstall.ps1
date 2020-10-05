$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = 'az'  # this may be different from the package name and different case
$moduleVersion = $env:ChocolateyPackageVersion  # this may change so keep this here
$savedParamsPath = Join-Path $toolsDir -ChildPath 'parameters.saved'
$depModulesPath = Join-Path $toolsdir -ChildPath 'dependent.modules'

# module may already be installed outside of Chocolatey
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

# remove the saved parameters file if it exists
if (Test-Path -Path $savedParamsPath) {
    Remove-Item -Path $savedParamsPath -Force
}

$params = Get-PackageParameters

# Taken from the AZ.psm1 script module - allows us to detect this at installatin rather than after
# Note that this is not added as a dependency as if you intend to run this in PS Core, .NET 4.7.2 is not required.
function Test-DotNet {
    try {
        if ((Get-PSDrive 'HKLM' -ErrorAction Ignore) -and (-not (Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' -ErrorAction Stop | Get-ItemPropertyValue -ErrorAction Stop -Name Release | where { $_ -ge 461808 }))) {
            throw ".NET Framework versions lower than 4.7.2 are not supported in Az.  Please upgrade to .NET Framework 4.7.2 or higher."
        }
    }
    catch [System.Management.Automation.DriveNotFoundException] {
        Write-Verbose ".NET Framework version check failed."
    }
}

if ($params.Desktop) {
    if ($PSVersionTable.PSVersion -lt [Version]'5.1') {
        throw "PowerShell versions lower than 5.1 are not supported in Az. Please upgrade to PowerShell 5.1 or higher."
    }

    Test-DotNet
}

$sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename.zip"
$destinationPath = @()
if ($params.Desktop -or (-not $params.Core)) {
    $destinationPath += Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\"
}

if ($params.Core) {
    $destinationPath += Join-Path -Path $env:ProgramFiles -ChildPath "PowerShell\Modules\"
}

ForEach ($destPath in $destinationPath) {
    Write-Verbose "Installing '$modulename', and all of it's dependent modules, to '$destPath'."

    # check destination path exists and create if not
    if (Test-Path -Path $destPath) {
        $null = New-Item -Path $destPath -ItemType Directory -Force
    }
    Get-ChocolateyUnzip -FileFullPath $sourcePath -Destination $destPath -PackageName $moduleName

    # save the locations where the module was installed so we can uninstall it
    Add-Content -Path $savedParamsPath -Value $destPath
}

# cleanup the module from the Chocolatey $toolsDir folder
Remove-Item -Path $sourcePath -Force -Recurse