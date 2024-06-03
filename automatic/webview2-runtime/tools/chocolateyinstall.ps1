$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE' #only one of these: exe, msi, msu
  url           = 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/368f1305-6fe1-40e2-81b8-e305f6821b37/MicrosoftEdgeWebView2RuntimeInstallerX86.exe'
  url64         = 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/35ae885b-96ae-4a0e-8cfe-2e50c769ad87/MicrosoftEdgeWebView2RuntimeInstallerX64.exe'
  softwareName  = 'Microsoft Edge WebView2*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  checksum      = '069d2448c02180a3dc671b79eb2ae572cac7933c540974abb94ed2b7ac5ee278'
  checksum64    = '9e539ff7473256ca5ced0076f2441a5607be6b638c11d77686db16922527b279'
  checksumType  = 'sha256'

  silentArgs    = '/silent /install'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
