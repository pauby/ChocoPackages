$ErrorActionPreference = 'Stop'

$internalAppXPackage = @{
    SoftwareName = 'Microsoft.UI.Xaml'
    PackageName  = 'Microsoft.Ui.Xaml.2.7'
    Version      = '7.2109.13004.0'
}

$installedAppXPackage = Get-AppxPackage | Where-Object -Property Name -eq $internalAppXPackage.PackageName

Write-Host "Removing version $($installedAppXPackage.Version) of $($internalAppXPackage.PackageName)."
Remove-AppxPackage -Package $installedAppXPackage.PackageFullName