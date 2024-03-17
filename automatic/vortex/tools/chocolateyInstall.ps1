$ErrorActionPreference = 'Stop'

$packageName = 'vortex'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$fileLocation = 'vortex-setup-1.10.7.exe'

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  file           = Join-Path -Path $toolsDir -ChildPath $fileLocation
  silentArgs     = "/S"
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

# Remove the installers as there is no more need for it
Remove-Item $toolsDir\*.exe -ea 0 -Force
