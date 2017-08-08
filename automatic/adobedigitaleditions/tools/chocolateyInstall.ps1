$ErrorActionPreference = 'Stop';

$packageName= 'adobedigitaleditions'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://adedownload.adobe.com/pub/adobe/digitaleditions/ADE_4.5_Installer.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'adobedigitaleditions*'

  checksum      = 'ed9e11cb1d4fe22b7fc3af94752d832504a0e9efa502a3d529176736db9bf188'
  checksumType  = 'SHA256'

  silentArgs   = '/S'
  # Note code 1223 is added as valid for v4.5.5 as it exits with this code but appears to install correctly
  # see https://forums.adobe.com/thread/2345991
  validExitCodes= @(0, 1223)
}

$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path $toolsDir "adobedigitaleditions_Install.ahk"
$ahkProc = Start-Process -FilePath $ahkExe `
                         -ArgumentList $ahkFile `
                         -PassThru

$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyPackage @packageArgs
