$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    softwareName   = 'pdfFactory Pro'
    fileType       = 'EXE'
    silentArgs     = '/uninstall /quiet /reboot=0'
    validExitCodes = @(1)
}

[array]$key = Get-UninstallRegistryKey @packageArgs
if ($key.Count -eq 1) {
    $key | ForEach-Object { 
        # some uninstall strings include parameters - remove them as we will use our own
        $packageArgs.file = "$($_.UninstallString)" -replace '/.*$', ''

        if ($packageArgs.fileType -eq 'MSI') {
            $packageArgs.silentArgs = "$($_.PSChildName) $($packageArgs.silentArgs)"
            $packageArgs.file = ''
        }

        Uninstall-ChocolateyPackage @packageArgs
    }
}
elseif ($key.Count -eq 0) {
    Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
}
elseif ($key.Count -gt 1) {
    Write-Warning "$key.Count matches found!"
    Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
    Write-Warning "Please alert package maintainer the following keys were matched:"
    $key | ForEach-Object {
        Write-Warning "- $_.DisplayName"
    }
}