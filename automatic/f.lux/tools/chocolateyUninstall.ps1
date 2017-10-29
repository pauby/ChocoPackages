$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    softwareName   = "f.lux*" 
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

# The uninstall doesn't appear to stop the process
Write-Verbose "Stopping the 'flux' process if it is running."
Get-Process -Name 'flux' -ErrorAction SilentlyContinue | Stop-Process

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs.softwareName
if ($key.Count -eq 1) {
    $key | % {
        $packageArgs.file = $_.UninstallString
        Uninstall-ChocolateyPackage @packageArgs
    }
}
elseif ($key.Count -eq 0) {
    Write-Warning "$packageName has already been uninstalled by other means."
}
elseif ($key.Count -gt 1) {
    Write-Warning "$key.Count matches found!"
    Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
    Write-Warning "Please alert package maintainer the following keys were matched:"
    $key | % {Write-Warning "- $_.DisplayName"}
}