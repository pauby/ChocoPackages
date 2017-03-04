$ErrorActionPreference = 'Stop';

$packageName = 'pdffactorypro-workstation'
$softwareName = 'pdfFactory Pro'
$installerType = 'EXE'

$silentArgs = '/uninstall /quiet /reboot=0'
$validExitCodes = @(1)

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName
if ($key.Count -eq 1) {
  $key | % {
    $file = "$($_.UninstallString)"
    # this uninstall string contains a parameter /uninstall - remove this or the
    # Uninstall-ChocolateyPackage won't work
    if ($file.Contains('/')) {
        $file = $file.Split('/')[0].Trim()  # return just the filepath part
    }

    if ($installerType -eq 'MSI') {
      $silentArgs = "$($_.PSChildName) $silentArgs"
      $file = ''
    }

    Uninstall-ChocolateyPackage -PackageName $packageName `
                                -FileType $installerType `
                                -SilentArgs "$silentArgs" `
                                -ValidExitCodes $validExitCodes `
                                -File "$file"
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$key.Count matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $_.DisplayName"}
}