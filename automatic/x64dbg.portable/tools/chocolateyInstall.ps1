$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$archiveFilename = ''

. $(Join-Path -Path $toolsDir -ChildPath "StopProcess.ps1")

$packageArgs = @{
    PackageName   = $env:ChocolateyPackageName
    FileFullPath  = Join-Path -Path $toolsdir -ChildPath $archiveFilename
    Destination   = $toolsDir
}

Get-ChocolateyUnzip @packageArgs

Get-ChildItem -Path $toolsDir -File -Filter "*.exe" -Exclude "x*dbg.exe" -Recurse | ForEach-Object {
    New-Item "$($_.FullName).ignore" -Type File -Force | Out-Null
}
