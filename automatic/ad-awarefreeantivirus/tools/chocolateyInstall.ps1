$ErrorActionPreference = 'Stop';

$packageName = 'ad-awarefreeantivirus'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'http://download100.lavasoft.com/adaware/updates/Adaware_Installer_free.exe'

$ahkFile = 'ad-awarefreeantivirus_install.ahk'
$ahkPath = $(Join-Path -Path $toolsDir -ChildPath $ahkFile)

$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'EXE'
    url            = $url

    softwareName   = 'adaware antivirus*'

    checksum       = 'dc3e21115ef6d474175159bd3433bc526b2f56cc7677ecff2f46472c46b4e0c6'
    checksumType   = 'SHA256'

    validExitCodes = @(0)
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
