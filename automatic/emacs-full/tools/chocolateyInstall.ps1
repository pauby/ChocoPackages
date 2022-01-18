Import-Module "$(Split-Path -parent $MyInvocation.MyCommand.Definition)/install.psm1"

Install-ChocolateyZipPackage @FullPackageArgs

New-ShimHintFiles
