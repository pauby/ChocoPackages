$ErrorActionPreference = 'Stop'

# This code is borrowed from the awesome Microsoft-Windows-Terminal package
# https://community.chocolatey.org/packages/microsoft-windows-terminal
#
# This can only be installed in a user context. You cannot use Add-AppXPackage -AllUsers (as the parameter is not
# supported). You cannot use *-AppxProvisionedPackage as it produced an unspecified error.

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$internalAppXPackage = @{
  SoftwareName = 'Microsoft.UI.Xaml'
  PackageName = 'Microsoft.Ui.Xaml.2.7'
  Version = '7.2109.13004.0'
}

$appxFileName = 'Microsoft.UI.Xaml.2.7.appx'
$packagedAppxVersion = '2.7.0'

$windowsVersion = [Environment]::OSVersion.Version
if ($windowsVersion.Major -ne "10") {
  throw "This package requires Windows 10 / Server 2019."
}
# .appx is not supported on Windows 10 version 1709 and 1803. https://docs.microsoft.com/en-us/windows/msix/msix-1709-and-1803-support
if ($windowsVersion.Build -lt "17763") {
  throw "This package requires at least Windows 10 / Server 2019 version 1809 / OS build 17763.x. See https://github.com/microsoft/microsoft-ui-xaml#version-support for more information."
}

$installedAppXPackage = Get-AppxPackage | Where-Object -Property Name -eq $internalAppXPackage.PackageName

$removeAppXPackage = $false
if ([version]$installedAppXPackage.Version -gt [version]$internalAppXPackage.Version) {
  # you can't install an older version of an installed appx package, you'd need to remove it first
  Write-Warning "The installed $installedAppxVersion version is newer than this package version, it may have been automatically updated on your computer."
  $removeAppXPackage = $true
}
elseif ([version]$installedAppXPackage.Version -eq [version]$internalAppxPackage.Version) {
  if ($env:ChocolateyForce) {
    # you can't install the same version of an appx package, you need to remove it first
    Write-Host 'Removing already installed version.'
    $removeAppXPackage = $true
  }
  else {
    Write-Host "The $($internalAppXPackage.Version) version of $($internalAppXPackage.PackageName) is already installed. If you want to reinstall use --force."
    return
  }
}

if ($removeAppXPackage) {
  Write-Host "Removing version $($installedAppXPackage.Version) of $($internalAppXPackage.PackageName)."
  Remove-AppxPackage -Package $installedAppXPackage.PackageFullName
}

Add-AppXPackage -Path (Join-Path -Path $toolsDir -ChildPath $appxFileName)

Write-Warning 'Note that the Microsoft collects data when the Microsoft.UI.Xaml software is installed.'
Write-Warning 'Please see:'
Write-Warning '    https://github.com/microsoft/microsoft-ui-xaml#datatelemetry'
Write-Warning '    https://github.com/microsoft/microsoft-ui-xaml/blob/main/docs/developer_guide.md#telemetry'