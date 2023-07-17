$ErrorActionPreference = 'Stop'

$toolsDir       = $(Split-Path -Parent $MyInvocation.MyCommand.Definition)

# Start Autohotkey install script
$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path -Path $env:TEMP -ChildPath "$(Get-Random).ahk" 
$ahkSourceFile = Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)-install.ahk"
Copy-Item -Path $ahkSourceFile -Destination $ahkFile

Write-Verbose "Running AutoHotkey install script $ahkFile"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

$packageArgs = @{
  packageName    = 'ipvanish'
  softwareName   = 'ipvanish*'
  fileType       = 'exe'
  url            = 'https://www.ipvanish.com/software/setup-prod-v2/ipvanish-setup.exe'
  checksum       = 'cc339d4e26d90526abfdd40b4c65863803d07f4eda3e886568a33e38b1f5ec4d'
  checksumType   = 'sha256'
  silentArgs     = ''
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

Remove-Item -Path $ahkFile -Force -ErrorAction SilentlyContinue