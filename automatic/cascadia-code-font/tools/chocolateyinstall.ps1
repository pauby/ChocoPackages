$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fontFiles = Get-ChildItem -Path $toolsDir -Include '*.ttf' -Recurse | Select-Object -ExpandProperty FullName
# Function does not use recommended parameter name so use plural instead of singular
$installedFonts = Install-ChocolateyFont -Paths $fontFiles -Multiple

if ($InstalledFonts -eq 0) {
   throw 'All font installation attempts failed!'
}
elseif ($installedFonts` -lt $fontFiles.count) {
   Write-Warning ("{0} fonts failed to install." -f (@($fontFiles).count - @($installedFonts).count))
}

Write-Host ("{0} fonts were installed." -f @($installedFonts).count)
