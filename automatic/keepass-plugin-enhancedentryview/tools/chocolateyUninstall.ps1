$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName = $env:ChocolateyPackageName
    zipFileName = "KPEnhancedEntryView-v$($env:ChocolateyPackageVersion).zip"
}

Uninstall-ChocolateyZipPackage @packageArgs