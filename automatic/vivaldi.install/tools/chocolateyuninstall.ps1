$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    softwareName   = 'vivaldi*'
    fileType       = 'EXE'
    silentArgs     = '--uninstall --force-uninstall --vivaldi --system-level'
    validExitCodes = @(0, 19)   # no matter the combination of switches I use, 19 is always the exit code
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs.softwareName
if ($key.Count -eq 1) {
    $key | ForEach-Object {
        # The uninstall string looks something like '"C:\Program Files\Vivaldi\Application\6.5.3206.63\Installer\setup.exe" --uninstall --vivaldi-install-dir="C:\Program Files\Vivaldi" --system-level'
        # we want to grab the bit between the first set of double quotes, i.e. "C:\Program Files\Vivaldi\Application\6.5.3206.63\Installer\setup.exe"
        #! This string is DIFFERENT from the portable package
        $_.UninstallString -match '".*?"' | Out-Null
        $packageArgs.file = $matches[0]

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
    $key | ForEach-Object {
        Write-Warning "- $_.DisplayName"
    }
}