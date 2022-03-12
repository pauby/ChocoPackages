$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Microsoft Edge WebView2 Runtime'
  fileType      = 'EXE'
  # MSI
  silentArgs    = '--uninstall --msedgewebview --system-level --verbose-logging --force-uninstall'
  validExitCodes = @(0, 19)   # no matter the combination of switches I use, 19 is always the exit code
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
    $packageArgs['file'] = ($key.UninstallString).replace(' --uninstall --msedgewebview --system-level --verbose-logging', '')

    Uninstall-ChocolateyPackage @packageArgs
}
elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
}
elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}
