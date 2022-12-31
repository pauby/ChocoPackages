$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$pp = Get-PackageParameters
if (!$pp.Path) {
   $UnzipPath = Get-ToolsLocation
   Write-Host "Solr will be unpacked to the default location, '$UnzipPath'."
}
else {
   # make sure the path string is valid
   $null = [system.io.fileinfo]($pp.Path)
   Write-Host "Solr will be unpacked to the custom location, '$($pp.Path)'."
   Write-Warning 'Custom locations are not identified or cleared on Chocolatey package upgrade or uninstall.'
   $UnzipPath = $pp.Path
}

$packageArgs = @{
   PackageName   = 'solr'
   url           = 'https://www.apache.org/dyn/closer.lua/lucene/solr/8.11.2/solr-8.11.2.zip?action=download'
   unzipLocation = $UnzipPath
   checksum      = 'ccd6032b5f9e9013facfa66dc2e8e07f82f9d90241e8ead1011ed27b6f61d64d3d34a9060fcac9025efd5bf0b5bae994c7f1ce72a91fabaf236dbcaa1cf3cd1f'
   checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs