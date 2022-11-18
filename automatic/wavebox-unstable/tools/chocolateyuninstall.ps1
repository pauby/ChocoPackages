$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = '*Wavebox*'
  fileType      = 'EXE'
  silentArgs    = "--uninstall -s"
  validExitCodes= @(0, 3010, 1641, 19)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    # the uninstall string contains arguments which break Uninstall-ChocolateyPackage as it isn't expecting any in
    # that string. Lets just grab the installer EXE and then add the args to the silentArgs field in the hashtable
    # Get-UninstallChocolateyPackage will then put everything together
    $_.UninstallString -match '^".*"' | Out-Null
    $packageArgs['file'] = $matches[0]
    Uninstall-ChocolateyPackage @packageArgs
  }
}
elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
}
elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}