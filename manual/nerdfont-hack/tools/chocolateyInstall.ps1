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

$fontCount = (Get-ChildItem -Path $tempPath -Include '*.ttf').count
$fontInstalled = Install-ChocolateyFont $tempPath -Multiple

if ($fontInstalled -ne $fontCount) {
    throw ("{0} fonts out {1] failed to install." -f $fountCount - $fontInstalled, $fountCount)
}