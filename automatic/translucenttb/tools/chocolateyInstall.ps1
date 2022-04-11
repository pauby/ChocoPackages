$ErrorActionPreference = 'Stop'

# Code taken from the awesome microsoft-windows-terminal package
# https://community.chocolatey.org/packages/microsoft-windows-terminal/

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$fileName = Join-Path -Path $toolsDir -ChildPath 'translucenttb.msixbundle'
$version = '2021.5' # needed in case we have package fix versions
$AppxPackageName = '28017CharlesMilette.TranslucentTB'

$windowsVersion = [Environment]::OSVersion.Version
if ($windowsVersion.Major -lt 10) {
    # I'm assuming this works on Windows 11 if it works on 10
    throw "This package requires Windows 10 as a minimum."
}

# The .msixbundle format is not supported on Windows 10 version 1709 and 1803. https://docs.microsoft.com/en-us/windows/msix/msix-1709-and-1803-support
if ($windowsVersion.Build -lt 18362) {
    throw "This package requires at least Windows 10 version 1903, OS build 18362.x."
}

if ((Get-AppxPackage -Name $AppxPackageName).Version -Match $version) {
    if ($env:ChocolateyForce) {
        # you can't install the same version of an appx package, you need to remove it first
        Write-Verbose 'Forced install. Must remove currently installed version.'
        Get-AppxPackage -Name $AppxPackageName | Remove-AppxPackage
    }
    else {
        Write-Warning "Version $version of $($env:ChocolateyPackageName) is already installed. To reinstall use the --force switch on the command line."
        return
    }
}

Add-AppxPackage -Path $fileName -ForceTargetApplicationShutdown
