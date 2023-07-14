$ErrorActionPreference = 'Stop'

# This can only be installed in a user context (*-AppxPackage).
# You cannot use *-AppxProvisionedPackage as it produced 'Element not found'.

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

. $(Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)-helpers.ps1")

$appxFileNamex86 = 'Microsoft.VCLibs.x86.14.00.Desktop.appx'
$appxFileNamex64 = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'

$windowsVersion = [Environment]::OSVersion.Version
if ($windowsVersion.Major -lt "10") {
    throw "This package requires a minimum of Windows 10 / Server 2019."
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

# For x64, the x86 version of the package is always installed too by the looks of it
$downloadArguments = @{
    packageName  = $env:ChocolateyPackageName
    fileFullPath = Join-Path -Path $toolsDir -ChildPath $appxFileNamex86
    url          = 'https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx'
    checksum     = '3195DB914BEA1534EE73582CD483C548A929AED2799D305B3BBF7411BA7A6C7D'
    checksumType = 'SHA256'
}

Get-ChocolateyWebFile @downloadArguments
Add-AppxPackage -Path (Join-Path -Path $toolsDir -ChildPath $appxFileNamex86)

if (Get-OSArchitectureWidth -eq '64') {
    $downloadArguments = @{
        packageName  = $env:ChocolateyPackageName
        fileFullPath = Join-Path -Path $toolsDir -ChildPath $appxFileNamex64
        url          = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
        checksum     = '9BFDE6CFCC530EF073AB4BC9C4817575F63BE1251DD75AAA58CB89299697A569'
        checksumType = 'SHA256'
    }

    Get-ChocolateyWebFile @downloadArguments
    Add-AppxPackage -Path (Join-Path -Path $toolsDir -ChildPath $appxFileNamex64)
}