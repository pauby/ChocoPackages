$ErrorActionPreference = 'Stop'

$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    softwareName  = 'ManyCam Virtual Webcam*'
    fileType      = 'EXE'
    url           = 'https://download3.manycams.com/installer/ManyCamSetup.exe'
    checksum      = '85F77C6F5BDD422FFB07879CE60B992F91E968401E8B187B6ABAC8103A4F8406'
    checksumType  = 'SHA256'
    silentArgs    = '/S'
    # The installer seems to exit with code -1073741819 even though it installs silently. Tested on multiple machines.
    validExitCodes = @(0, -1073741819)
}

# Write-debug "OS Name: $($env:OS_NAME)"
# if ($env:OS_NAME -like "*Server*") {
#     throw "Cannot be installed on a Server operating system ($($env:OS_NAME))."
# }

$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path -Path $env:TEMP -ChildPath "$(Get-Random).ahk"
$ahkSourceFile = Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)_install.ahk"
Copy-Item -Path $ahkSourceFile -Destination $ahkFile -Force | Out-Null

Write-Verbose "Running AutoHotkey install script $ahkFile"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyPackage @packageArgs

$startFolderPath = Join-Path -Path ([Environment]::GetFolderPath('StartMenu')) -ChildPath 'Programs\ManyCam'
if (-not (Test-Path -Path $startFolderPath)) {
    $exePath = Join-Path -Path ([Environment]::GetFolderPath('ProgramFilesX86')) -ChildPath 'ManyCam\ManyCam.exe'
    $shortcutPath = Join-Path -Path $startFolderPath -ChildPath 'ManyCam.lnk'
    Install-ChocolateyShortcut -ShortcutFilePath $shortcutPath -TargetPath $exePath
}

Remove-Item $ahkFile -Force -ErrorAction SilentlyContinue