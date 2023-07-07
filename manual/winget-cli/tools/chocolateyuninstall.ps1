$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

. $(Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)-helpers.ps1")

$allAppXPackages = Get-AppxPackage
# there is likely going to be two packages returned for x86 and x64.
# we don't care about the architecture, just the version and they will both be the same.
$installedAppXPackage = @($allAppXPackages | Where-Object -Property Name -eq $internalAppXPackage.PackageName)
if ($installedAppXPackage.Count -gt 0) {
    # check there are no packages that take our package as a dependency
    if (Test-AppXDependency -Name $internalAppXPackage.PackageName -PackageList $allAppXPackages) {
        Write-Warning "We cannot remove $($internalAppXPackage.PackageName) as it is a dependency of another AppX package. Please remove it manually and then install this package again."
        return
    }
    else {
        # when you remove a package, you don't remove it per architecture. You just remove it for all architectures.
        Write-Host "Attempting to remove $($internalAppXPackage.PackageName). Note that this may fail and you will therefore have to remove it manually."
        $null = Remove-AppxProvisionedPackage -PackageName $installedAppXPackage.PackageName -Online
    }
}
else {
    Write-Warning "The $($internalAppXPackage.PackageName) AppX package does not appear to be installed."
}