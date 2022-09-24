$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://edge.elgato.com/egc/windows/sd/Stream_Deck_OBS_Plugin_5.3.2.35.msi'

$ahkFile = 'streamdeck-obs-studio-plugin_install.ahk'
$ahkPath = $(Join-Path -Path $toolsDir -ChildPath $ahkFile)

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'MSI'
  url64bit       = $url64

  softwareName   = 'Elgato Stream Deck OBS Plugin*'

  checksum64     = 'A5CC1E98152B1E8AEFF83D61B2D16E153A1B888B96AB708D285850CB72CAE56B'
  checksumType64 = 'sha256' #default is checksumType

  # MSI
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs

$pluginPath = Join-Path -Path $toolsDir -ChildPath 'com.elgato.obsstudio.streamDeckPlugin'
$pluginArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileFullPath   = $pluginPath
  url64bit       = 'https://edge.elgato.com/egc/sd_content/com.elgato.obsstudio.streamDeckPlugin'
  checksum64     = 'AF6812FBEADFEC31704EEAC9B922D223AD48DB0CFA4421DF96AE0CD9BD9CB988'
  checksumType64 = 'sha256'
}

Get-ChocolateyWebFile @pluginArgs

$ahkRun = "$Env:Temp\$(Get-Random).ahk"
Write-Debug "AHK file to run: $ahkRun"
Copy-Item $ahkPath $ahkRun -Force
$ahkProc = Start-Process -FilePath 'AutoHotKey' `
  -ArgumentList $ahkRun `
  -PassThru

$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Start-ChocolateyProcessAsAdmin -Statements "$pluginPath"
