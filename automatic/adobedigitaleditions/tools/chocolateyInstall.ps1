$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$ahkFile = 'adobedigitaleditions_install.ahk'
$ahkPath = $(Join-Path -Path $toolsDir -ChildPath $ahkFile)

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    fileType      = 'EXE'
    url           = 'https://adedownload.adobe.com/pub/adobe/digitaleditions/ADE_4.5_Installer.exe'
    checksum      = 'F3F72254F1C630B3900D5EE18DF1C0990FFCE631B60DD6DE2D19420476E524E5'
    checksumType  = 'SHA256'

    silentArgs   = '/S'
    # Note code 1223 is added as valid for v4.5.5 as it exits with this code but appears to install correctly
    # see https://forums.adobe.com/thread/2345991
    validExitCodes= @(0, 1223)
}

$ahkRun = "$Env:Temp\$(Get-Random).ahk"
Write-Debug "AHK file to run: $ahkRun"
Copy-Item $ahkPath $ahkRun -Force
$ahkProc = Start-Process -FilePath 'AutoHotKey' `
    -ArgumentList $ahkRun `
    -PassThru

$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyPackage @packageArgs
