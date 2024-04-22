$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE' #only one of these: exe, msi, msu
  url           = 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/b87a52b9-351d-4b15-af14-70a878199712/MicrosoftEdgeWebView2RuntimeInstallerX86.exe'

  softwareName  = 'Microsoft Edge WebView2*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  checksum      = '0ecb676812c9372a14203e3949394df3ca736e4e8d3f2784767154ab32572eef'
  checksumType  = 'sha256'

  silentArgs    = '/silent /install'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
