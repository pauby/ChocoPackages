$ErrorActionPreference = 'Stop'

# This code is borrowed from the awesome Microsoft-Windows-Terminal package
# https://community.chocolatey.org/packages/microsoft-windows-terminal
#
# This can only be installed in a user context. You cannot use Add-AppXPackage -AllUsers (as the parameter is not
# supported). You cannot use *-AppxProvisionedPackage as it produced an unspecified error.

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

. $(Join-Path -Path $toolsDir -ChildPath 'microsoft-ui-xaml-helpers.ps1')

$windowsVersion = [Environment]::OSVersion.Version
if ($windowsVersion.Major -ne "10") {
    throw "This package requires Windows 10 / Server 2019."
}
# .appx is not supported on Windows 10 version 1709 and 1803. https://docs.microsoft.com/en-us/windows/msix/msix-1709-and-1803-support
if ($windowsVersion.Build -lt "17763") {
    throw "This package requires at least Windows 10 / Server 2019 version 1809 / OS build 17763.x. See https://github.com/microsoft/microsoft-ui-xaml#version-support for more information."
}

$removeAppXPackage = $false         # used to indicate if we should remove the currently installed AppX package before continuing
# get all of the packages as we may need to use that later
$allAppXPackages = Get-AppXPackage
# there is likely going to be two packages returned for x86 and x64.
# we don't care about the architecture, just the version and they will both be the same.
$installedAppXPackage = @($allAppXPackages | Where-Object -Property Name -eq $internalAppXPackage.PackageName)
if ($installedAppXPackage.Count -gt 0) {
    if ([version]$installedAppXPackage[0].Version -gt [version]$internalAppXPackage.Version) {
        # you can't install an older version of an installed appx package, you'd need to remove it first
        # we also don't want to remove later versions as they will have been installed outside of the package ecosystem
        # and may have been installed for very good reasons by another application.
        # if the user pases the `-f` or `--force` option to Chocolatey CLI we can attempt uninstall
        Write-Warning "The installed $($installedAppXPackage[0].Version) version of the AppX package is newer than the version this Chocolatey package installs, $($internalAppXPackage.Version)."
        Write-Warning "It may have been automatically updated on your computer as part of a Windows Update or another application."

        if ($env:ChocolateyForce) {
            Write-Host "The '--force' option has been used so we will attempt to remove this later version."
            $removeAppXPackage = $true
        }
        else {
            # we will not throw an error if a later version of the AppX package is detected
            Write-Warning "We cannot install this package version over the later version without uninstalling it first. Please remove it manually, or run the install command, adding the '--force' option to try and uninstall the later version."
            return
        }
    }
    elseif ([version]$installedAppXPackage[0].Version -eq [version]$internalAppxPackage.Version) {
        if ($env:ChocolateyForce) {
            # you can't install the same version of an appx package, you need to remove it first
            Write-Host "The '--force' option has been used so we will attempt to remove the already installed version."
            $removeAppXPackage = $true
        }
        else {
            Write-Warning "The $($internalAppXPackage.Version) version of $($internalAppXPackage.PackageName) is already installed. If you want to reinstall, add the '--force' option on the command line."
            return
        }
    }
}

if ($removeAppXPackage) {
    # we need to check we CAN remove the package - if it is a dependent package, it will fail if we try
    if (Test-AppXDependency -Name $internalAppXPackage.PackageName -PackageList $allAppXPackages) {
        Write-Warning "We cannot remove version $($installedAppXPackage[0].Version) of $($internalAppXPackage.PackageName) as it is a dependency of another AppX package. Please remove it manually and then install this package again."
        return
    }

    # when you remove a package, you don't remove it per architecture. You just remove it for all architectures.
    Write-Host "Attempting to remove version $($installedAppXPackage[0].Version) of $($internalAppXPackage.PackageName). Note that this may fail and you will therefore have to remove it manually."
    Remove-AppxPackage -Package $installedAppXPackage[0].PackageFullName
}

Add-AppxPackage -Path (Join-Path -Path $toolsDir -ChildPath "x86-$($appxFileName)")

if (Get-OSArchitectureWidth -eq '64') {
    Add-AppXPackage -Path (Join-Path -Path $toolsDir -ChildPath "x64-$($appxFileName)")
}

Write-Warning 'Note that Microsoft may collect data when the Microsoft.UI.Xaml software is installed.'
Write-Warning 'Please see:'
Write-Warning '    https://github.com/microsoft/microsoft-ui-xaml#datatelemetry'
Write-Warning '    https://github.com/microsoft/microsoft-ui-xaml/blob/main/docs/developer_guide.md#telemetry'