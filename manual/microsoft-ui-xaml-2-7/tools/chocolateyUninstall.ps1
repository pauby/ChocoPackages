$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

. $(Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)-helpers.ps1")

$failToRemove = $false
Get-AppxProvisionedPackage -Online | Where-Object -Property DisplayName -eq $internalAppXPackage.PackageName | ForEach-Object {
    # sometimes this cmdlet throws an error about a conflict ir dependency but goes ahead and removes it anyway. 
    # this is why we are trapping it. We check if the packages have actually been removed, below.
    try {
        Remove-AppxProvisionedPackage -Packagename $_.PackageName -AllUsers -Online | Out-Null 
    }
    catch {
        $failToRemove = $true
    }
}

if ($failToRemove) {
    # Lets check if the packages actually didn't get removed
    if (@(Get-AppxProvisionedPackage -Online | Where-Object -Property DisplayName -eq $internalAppXPackage.PackageName) -gt 0) {
        Write-Warning "At least one app package architecture failed to uninstall. PLease uninstall it manually."
    }
}