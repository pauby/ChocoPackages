$ErrorActionPreference = 'Stop'

# This can be installed in both a user (using *-AppxPackage) and system (using *-AppxProvisionedPackagtecontext.
# It was decided to use the user context as that works with Windows Server 2019 where as the system context doesn't.

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

. $(Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)-helpers.ps1")

$windowsVersion = [Environment]::OSVersion.Version
if ($windowsVersion.Major -ne "10") {
    throw "This package requires Windows 10 / Server 2019."
}

# .appx is only  supported on Windows 10 version 1709 and later - https://learn.microsoft.com/en-us/windows/msix/supported-platforms
# See https://en.wikipedia.org/wiki/Windows_10_version_history for build numbers
if ($windowsVersion.Build -lt "16299") {
    throw "This package requires a minimum of Windows 10 / Server 2019 version 1709 / OS build 16299."
}

$removeAppXPackage = $false         # used to indicate if we should remove the currently installed AppX package before continuing
# get all of the packages as we may need to use that later
$allAppXPackages = Get-AppxPackage
# there is likely going to be two packages returned for x86 and x64.
# we don't care about the architecture, just the version and they will both be the same.
$installedAppXPackage = @($allAppXPackages | Where-Object -Property Name -EQ $internalAppXPackage.PackageName)
if (($installedAppXPackage.Count -gt 0) -and ([version]$installedAppXPackage[0].Version -ge [version]$internalAppXPackage.Version)) {
    # You can't install an older version of an installed appx package, you'd need to remove it first.
    # We also don't want to remove later versions as they will have been installed outside of the package ecosystem
    #   and may have been installed for very good reasons by another application.
    # We also don't want to just remove the same version again either for similar reasons.
    # If the user pases the `-f` or `--force` option to Chocolatey CLI we can attempt uninstall
    Write-Warning "The installed version of the app package, $($installedAppXPackage[0].Version), is the same or newer than the version this Chocolatey package installs, $($internalAppXPackage.Version)."
    Write-Warning "It may have been automatically updated on your computer as part of a Windows Update or another application."

    if ($env:ChocolateyForce) {
        Write-Warning "The '--force' option has been used so we will attempt to remove version $($installedAppXPackage[0].Version) and install version $($internalAppXPackage.Version)."
        $removeAppXPackage = $true
    }
    else {
        # we will not throw an error if a later version of the AppX package is detected
        Write-Warning "We cannot install this package version, $($internalAppXPackage.Version), over the installed version, $($installedAppXPackage[0].Version), without removing it first. Please remove it manually, or add the '--force' option to the command line."
        return
    }
}

if ($removeAppXPackage) {
    # we need to check we CAN remove the package - if it is a dependent package, it will fail if we try
    if (Test-AppXDependency -Name $internalAppXPackage.PackageName -PackageList $allAppXPackages) {
        Write-Warning "We cannot remove version $($installedAppXPackage[0].Version) of $($internalAppXPackage.PackageName) as it is a dependency of another app package. Please remove it manually and then install this package again."
        return
    }

    # when you remove a package, you don't remove it per architecture. You just remove it for all architectures.
    Write-Warning "Attempting to remove version $($installedAppXPackage[0].Version) of $($internalAppXPackage.PackageName). Note that this may fail and you may have to remove it manually."
    Remove-AppxPackage -Package $installedAppXPackage[0].PackageFullName
}

Add-AppxPackage -Path (Join-Path -Path $toolsDir -ChildPath "x86-$($appxFileName)")

if (Get-OSArchitectureWidth -eq '64') {
    Add-AppxPackage -Path (Join-Path -Path $toolsDir -ChildPath "x64-$($appxFileName)")
}

Write-Warning "Note that Microsoft may collect data when the '$($internalAppXPackage.PackageName)' software is installed."
Write-Warning 'Please see:'
Write-Warning '    https://github.com/microsoft/microsoft-ui-xaml#datatelemetry'
Write-Warning '    https://github.com/microsoft/microsoft-ui-xaml/blob/main/docs/developer_guide.md#telemetry'