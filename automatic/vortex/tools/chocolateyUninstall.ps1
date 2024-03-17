$ErrorActionPreference = 'Stop'

$packageName = 'vortex'
$programUninstallEntryName = 'Vortex*'

$registry = Get-UninstallRegistryKey -SoftwareName $programUninstallEntryName
$file = $registry.UninstallString -replace ('/allusers', '')

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  silentArgs     = '/allusers /S'
  validExitCodes = @(0)
  file           = $file
}

Uninstall-ChocolateyPackage @packageArgs
