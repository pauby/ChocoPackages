$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$i = 0
do {
    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
    $i++
} while ((Test-Path -Path $tempPath) -and ($i -lt 100))

# check we've not hit the count limit
if ($i -ge 100) {
  Write-Error "We couldn't find a temp folder name to create! (count: $i)"
}

# Create the folder
$null = New-Item -ItemType Directory -Path $tempPath

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileFullPath   = Join-Path -Path $tempPath -ChildPath 'vboxadditions.iso'
  destination    = Join-Path -Path $tempPath -ChildPath 'extracted'
  fileType       = 'ZIP'
  url            = 'https://download.virtualbox.org/virtualbox/6.0.4/VBoxGuestAdditions_6.0.4.iso'
  checksum       = '749b0c76aa6b588e3310d718fc90ea472fdc0b7c8953f7419c20be7e7fa6584a'
  checksumType   = 'sha256'
}

Get-ChocolateyWebFile @packageArgs
Get-ChocolateyUnzip @packageArgs

$binX86Filename = 'VBoxWindowsAdditions-x86.exe'
$binX64Filename = 'VBoxWindowsAdditions-amd64.exe'
$installArgs = @{
  packageName = $env:ChocolateyPackageName
  fileType = 'EXE'
  file = Join-Path -Path $packageArgs.destination -ChildPath $binX86Filename
  file64 = Join-Path -Path $packageArgs.destination -ChildPath $binX64Filename
  silentArgs = '/S'
  validExitCodes = @(0)
}

$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path -Path $toolsDir -ChildPath "install.ahk"
Write-Verbose "Running AutoHotkey install script $ahkFile"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
Write-Debug "$ahkExe Start Time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Install-ChocolateyInstallPackage @installArgs
