$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    fileType      = 'msi'
    file          = Join-Path -Path $toolsDir -ChildPath 'jenkins.msi'
    silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
    validExitCodes= @(0, 3010, 1641)
    softwareName  = 'Jenkins*'
}

Install-ChocolateyInstallPackage @packageArgs
