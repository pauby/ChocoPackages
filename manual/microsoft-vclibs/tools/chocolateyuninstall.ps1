$ErrorActionPreference = 'Stop'

$internalAppXPackage = @{
  SoftwareName = 'Microsoft.VCLibs'
  PackageName  = 'Microsoft.VCLibs.140.00.UWPDesktop'
  Version      = $env:ChocolateyPackageVersion
}

$installedAppXPackage = Get-AppxPackage | Where-Object -Property Name -eq $internalAppXPackage.PackageName

Write-Host "Removing version $($installedAppXPackage.Version) of $($internalAppXPackage.PackageName)."
Remove-AppxPackage -Package $installedAppXPackage.PackageFullName