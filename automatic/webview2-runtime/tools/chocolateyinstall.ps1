$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE' #only one of these: exe, msi, msu
  url           = 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/24fae4ef-a4bc-4139-a804-9e4cbf97ccd1/MicrosoftEdgeWebView2RuntimeInstallerX86.exe'

  softwareName  = 'Microsoft Edge WebView2*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  checksum      = '0229509659082820dd5cd66c2b96504f127fbd87346b32ea1305c3548d62b61b'
  checksumType  = 'sha256'

  silentArgs    = '/silent /install'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
