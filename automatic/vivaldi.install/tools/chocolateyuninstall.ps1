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
        # The uninstall string contains the --uninstall `--system-level` switch - we just want the file path
        #! This string is DIFFERENT from the portable package
        $packageArgs.file = $_.UninstallString.replace(' --uninstall --system-level', '')

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