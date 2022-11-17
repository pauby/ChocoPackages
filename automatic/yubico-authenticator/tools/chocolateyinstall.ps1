$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$installerFile = 'yubico-authenticator-6.0.0-win64.msi'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'MSI'
    file64         = Join-Path -Path $toolsDir -ChildPath $installerFile
    silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
    validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
