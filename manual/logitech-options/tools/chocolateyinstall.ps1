$ErrorActionPreference = 'Stop'

$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://download01.logi.com/web/ftp/pub/techsupport/options/Options_6.80.372.exe'
    checksum       = '2547498e32b106fb9b3a5365de50bc8eddef6ab0cd327d7dfdb352b65e1a8c3a'
    checksumType   = 'SHA256'
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

Remove-Item -Path $ahkFile -Force -ErrorAction SilentlyContinue