$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$fontZipFilename = "{0}.zip" -f $env:ChocolateyPackageName

do {
    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid().ToString())
}
while (Test-Path $tempPath)

$unzipArgs = @{
    packageName    = $env:ChocolateyPackageName
    FileFullPath   = Join-Path -Path $toolsDir -ChildPath $fontZipFilename
    Destination    = $tempPath
}

Get-ChocolateyUnzip @unzipArgs

$fontCount = (Get-ChildItem -Path $tempPath -Recurse -Filter '*.ttf').count
Write-Host "$fontCount fonts found to install."

$fontInstalled = Install-ChocolateyFont $tempPath -Multiple
Write-Host "$fontInstalled fonts installed."

if ($fontInstalled -ne $fontCount) {
    throw ("{0} fonts out {1} failed to install." -f ($fontCount - $fontInstalled), $fontCount)
}

# Remove our temporary files
Remove-Item $tempPath -Recurse -ErrorAction SilentlyContinue

Write-Warning 'If the fonts are not available in your applications or receive any errors installing or upgrading, please reboot to release the font files.'
