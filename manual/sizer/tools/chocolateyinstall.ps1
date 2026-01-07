$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$filename   = 'sizer4_dev640.msi'
$LogFile    = "`"$env:TEMP\chocolatey\$($env:ChocolateyPackageName)\$($env:ChocolateyPackageName).MsiInstall.log`""

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  file          = Join-Path -Path $toolsDir -ChildPath $filename

  silentArgs    = "/qn /norestart /l*v $LogFile"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
