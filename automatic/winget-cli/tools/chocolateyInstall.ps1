$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

. $(Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)-helpers.ps1")

$appxFileName = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
$appxLicenseFilename = 'License.xml'

# As the dependencies are all x64, I don't think this will run in x86
if (-not (Get-OSArchitectureWidth -eq '64')) {
    throw "'winget-cli' Requires Windows x64. Other architectures are not supported."
}

$windowsVersion = [Environment]::OSVersion.Version
if ($windowsVersion.Major -ne "10") {
    throw "'winget-cli' requires at least Windows 10 version 1809 (build 17763)."
}

# .appx is not supported on Windows 10 version 1709 and 1803. https://docs.microsoft.com/en-us/windows/msix/msix-1709-and-1803-support
if ($windowsVersion.Build -lt '17763') {
    throw "'winget-cli' requires at least Windows 10 version 1809 (build 17763). See https://github.com/microsoft/winget-cli#installing-the-client for more information."
}

# Winget-CLI is not supported on Server OS's but can be installed.
if ($env:OS_NAME -like "*Server*") {
    Write-Warning "This version of winget-cli is not officially supported on Windows Server operating systems."
    Write-Warning "It does not work on Windows Server 2019 and is not supported on Windows Server 2022."
    Write-Warning "It does however install, so we will continue and assume you know what you're doing!"
    Write-Warning "See https://github.com/microsoft/winget-cli#installing-the-client for more information."
}

# there is likely going to be two packages returned for x86 and x64.
# we don't care about the architecture, just the version, and they will both be the same.
$installedAppXPackage = @(Get-AppXProvisionedPackage -Online | Where-Object -Property DisplayName -eq $internalAppXPackage.PackageName)
if ($installedAppXPackage.Count -gt 0) {
    # we've found an already installed version of this app package

    if ([version]$installedAppXPackage[0].Version -gt [version]$internalAppXPackage.Version) {
        # we don't want to automatically remove later versions of app packages as they will have been installed 
        # outside of the Chocolatey package ecosystem and may have been installed for very good reasons by another application.
        # if the user pases the `-f` or `--force` option to Chocolatey CLI we can attempt uninstall
        Write-Warning "The installed version of the app package, $($installedAppXPackage[0].Version), is newer than the version this Chocolatey package installs, $($internalAppXPackage.Version)."
        Write-Warning "It may have been automatically updated on your computer as part of a Windows Update or another application."

        if (-not $env:ChocolateyForce) {
            # we will not throw an error if a later version of the AppX package is detected
            Write-Warning "To install the app version $($internalAppXPackage.Version) over the installed version $($installedAppXPackage[0].Version), please remove the installed version manually, or add '--force' option to the Chocolatey command line."
            return
        }
    }
    elseif ([version]$installedAppXPackage[0].Version -eq [version]$internalAppxPackage.Version) {
        Write-Warning "The installed version of the app package, $($installedAppXPackage[0].Version), is the same vesion that this Chocolatey package installs, $($internalAppXPackage.Version)."

        if (-not $env:ChocolateyForce) {
            # we will not throw an error if a later version of the AppX package is detected
            Write-Warning "To install the app version $($internalAppXPackage.Version) over the installed version $($installedAppXPackage[0].Version), please remove the installed version manually, or add '--force' option to the Chocolatey command line."
            return
        }
    }
}

if ($env:ChocolateyForce) {
    Write-Warning "The '--force' option has been used so we will attempt to install the app package version $($internalAppXPackage.Version)."
}

$appxPackageArgs = @{
    Online = $true
    PackagePath = (Join-Path -Path $toolsDir -ChildPath $appxFileName)
    LicensePath = (Join-Path -Path $toolsDir -ChildPath $appxLicenseFilename)
}

Add-AppXProvisionedPackage @appxPackageArgs | Out-Null

Write-Warning 'Note that the Microsoft may collect data when the WinGet-CLI software is installed.'
Write-Warning 'Please see https://github.com/microsoft/winget-cli#datatelemetry for more information on how to opt-out.'
