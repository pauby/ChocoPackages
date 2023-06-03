$ErrorActionPreference = 'Stop'

$internalAppXPackage = @{
    SoftwareName = 'WinGet-CLI'
    PackageName  = 'Microsoft.DesktopAppInstaller'
    Version      = '2023.417.2324.0'
}

$installedAppXPackage = Get-AppxProvisionedPackage -Online | Where-Object -Property DisplayName -EQ $internalAppXPackage.PackageName

Write-Host "Removing version $($installedAppXPackage.Version) of $($internalAppXPackage.PackageName)."
$null = Remove-AppxProvisionedPackage -PackageName $installedAppXPackage.PackageName -Online