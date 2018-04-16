$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'MSI'
    url64           = 'https://edge.elgato.com/egc/windows/sd/Stream_Deck_2.3.0.5268.msi'
    softwareName    = 'Elgato Stream Deck*'

    checksum64      = '74a51f6341621e413af017ac0158538e201635fe56eed679acba38243ebe9fc0'
    checksumType64  = 'SHA256'

    silentArgs      = "/quiet"
    validExitCodes  = @(0, 3010, 1641)
}

# get a temporary directory
do {
    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
} while (Test-Path $tempPath)
$packageArgs.fileFullPath = Join-Path -Path $tempPath -ChildPath "$packageName.$($packageArgs.fileType.ToLower())"

# Check OS version
write-debug "OS Name: $($env:OS_NAME)"
if ($env:OS_NAME -ne "Windows 10") {
    throw "Cannot be installed on this version of Windows - $packageName only supports Windows 10 x64 ($($env:OS_NAME))."
}

$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path $toolsDir "$($packageName)Install.ahk"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Get-ChocolateyWebFile @packageArgs 
Install-ChocolateyInstallPackage @packageArgs
