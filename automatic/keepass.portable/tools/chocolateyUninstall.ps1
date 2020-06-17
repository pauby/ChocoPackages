$ErrorActionPreference = 'Stop'

Uninstall-ChocolateyZipPackage -PackageName $env:ChocolateyPackageName -ZipFileName 'Keepass-Setup.zip'
Uninstall-BinFile -Name 'keepass'