$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'MSI'
    url64           = 'https://edge.elgato.com/egc/windows/sd/Stream_Deck_2.2.0.5165.msi'
    softwareName    = 'Elgato Stream Deck*'

    checksum64      = 'eba8372f26e92ac9d92ee0edc9051f9adceabbce72bf10f5ecfa2d4bcd54584a'
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