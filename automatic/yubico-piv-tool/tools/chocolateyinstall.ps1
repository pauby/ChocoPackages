$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    softwareName   = 'yubico piv tool*'
    fileType       = 'msi'
    file           = "$toolsDir\yubico-piv-tool-2.3.0-win32.msi"
    file64         = "$toolsDir\yubico-piv-tool-2.3.0-win64.msi"

    silentArgs    = "/quiet /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
    validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

# add the bin folder, in the install path, to the system path
$installPath = Get-AppInstallLocation -AppNamePattern 'yubico piv tool'
if (Test-Path -Path $installPath) {
    # path found add it to the system path
    $pathToAdd = Join-Path -Path $installPath -ChildPath 'bin'
    Install-ChocolateyPath -PathToInstall $pathToAdd -PathType 'Machine'

    $packageConfig = @{ UpdatedPath = $true; InstallPath = $pathToAdd }
}
else {
    $packageConfig = @{ UpdatePath = $false }
}

$packageConfig | ConvertTo-Json | Out-File (Join-Path -Path $toolsDir -ChildPath 'package-config.json')
