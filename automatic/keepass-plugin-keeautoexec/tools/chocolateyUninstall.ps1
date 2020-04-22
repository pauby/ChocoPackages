$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName = $env:ChocolateyPackageName
    zipFileName = "KeeAutoExec-$($env:ChocolateyPackageVersion).zip"
}

Uninstall-ChocolateyZipPackage @packageArgs