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
  checksum       = '5A2BB24368ECA12BB63F1BF16A1537866F7B6D35222AD5F84C27D91BEF00F9D2'
  checksumType   = 'SHA256'
  silentArgs     = ''
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

Remove-Item -Path $ahkFile -Force -ErrorAction SilentlyContinue
