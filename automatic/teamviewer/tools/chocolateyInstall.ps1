$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  softwareName  = 'TeamViewer*'

  url           = 'https://download.teamviewer.com/download/TeamViewer_Setup.exe'
  checksum      = 'f2aa91feccea466bd9c0440db1ade6e16b10f42897e30431996fc4d02ed500f5'
  checksumType  = 'sha256'

  url64         = 'https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe'
  checksum64    = 'fccef4dd9b654f98c100ab41a8e7e01d6257d496827caa740097e8a82e3e2054'
  checksumType64= 'sha256'

  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
