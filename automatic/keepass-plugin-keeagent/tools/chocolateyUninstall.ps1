$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName = $env:ChocolateyPackageName
    zipFileName = "KeeAgent_v$($env:ChocolateyPackageVersion).zip"
}

Uninstall-ChocolateyZipPackage @packageArgs