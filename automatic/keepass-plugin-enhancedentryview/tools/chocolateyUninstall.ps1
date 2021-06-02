$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName = $env:ChocolateyPackageName
    zipFileName = "KPEnhancedEntryView.zip"
}

Uninstall-ChocolateyZipPackage @packageArgs