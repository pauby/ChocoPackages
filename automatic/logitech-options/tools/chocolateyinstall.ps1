$ErrorActionPreference = 'Stop';

$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://download01.logi.com/web/ftp/pub/techsupport/options/Options_6.72.344.exe'
    checksum       = 'D1A44FA96049B8B0F9FB8A0B719588D7AE0DFEBE7770CA26AFF0A35D27FE502A'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = ''
    validExitCodes = @(0)   
}

$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path -Path $env:TEMP -ChildPath "$(Get-Random).ahk" 
$ahkSourceFile = Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)_install.ahk"
Copy-Item -Path $ahkSourceFile -Destination $ahkFile

Write-Verbose "Running AutoHotkey install script $ahkFile"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyPackage @packageArgs