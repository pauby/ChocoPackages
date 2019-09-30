$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

# Find which fonts were installed
$fontFiles = Get-ChildItem -Path $toolsDir -Include '*.ttf' -Recurse | Select-Object -ExpandProperty Name
# Uninstall function uses different parameters from install for some reason.
$removedFonts = Uninstall-ChocolateyFont -FontFiles $fontFiles -Multiple

if ($removedFonts -eq 0) {
   throw 'All font removal attempts failed!'
}
elseif ($removedFonts -lt @($fontFiles).count) {
   Write-Warning ("{0} fonts in package failed to uninstall." -f (@($FontFileNames).count - @($removedFonts).count))
   Write-Warning 'They may have failed to install or may have been removed by other means.'
}

Write-Host ("{0} fonts were uninstalled." -f @($removedFonts).count)