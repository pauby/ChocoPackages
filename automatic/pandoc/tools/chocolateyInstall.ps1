$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$logMsi = Join-Path -Path $env:TEMP -ChildPath ("{0}-{1}-MsiInstall.log" -f $env:ChocolateyPackageName, $env:chocolateyPackageVersion)
$file64Filename = 'pandoc-3.6.3-windows-x86_64.msi'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'MSI'
  file64         = Join-Path -Path $toolsDir -ChildPath $file64Filename
  silentArgs     = "/qn /norestart /l*v `"$logMsi`""
  #silentArgs     = '/quiet'
  validExitCodes = @(0, 1223)
  softwareName   = 'Pandoc *'
}
Install-ChocolateyInstallPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageArgs.softwareName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }

Write-Host "$packageName installed to '$installLocation'"
'pandoc', 'pandoc-citeproc' | % { Install-BinFile $_ $installLocation\$_.exe }
