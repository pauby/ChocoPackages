$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$logMsi = Join-Path -Path $env:TEMP -ChildPath ("{0}-{1}-MsiInstall.log" -f $env:ChocolateyPackageName, $env:chocolateyPackageVersion)
$installerFile = 'gh_2.16.1_windows_amd64.msi'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'MSI'
    silentArgs     = "/qn /norestart /l*v `"$logMsi`""
    file64         = Join-Path -Path $toolsDir -ChildPath $installerFile
}

Install-ChocolateyInstallPackage @packageArgs
