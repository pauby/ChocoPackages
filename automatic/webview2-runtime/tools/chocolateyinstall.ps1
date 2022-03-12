$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE' #only one of these: exe, msi, msu
  url           = 'https://go.microsoft.com/fwlink/p/?LinkId=2124703'

  softwareName  = 'Microsoft Edge WebView2*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  checksum      = '502b8140500de1b863bd018130de17afd95ca2d0bffc0d4dbf4964fd9f78cabf'
  checksumType  = 'sha256'

  silentArgs    = '/silent /install'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
