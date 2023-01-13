$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  softwareName  = 'TeamViewer*'

  url           = 'https://download.teamviewer.com/download/version_15x/TeamViewer_Setup.exe'
  checksum      = 'F2AA91FECCEA466BD9C0440DB1ADE6E16B10F42897E30431996FC4D02ED500F5'
  checksumType  = 'SHA256'

  url64         = 'https://download.teamviewer.com/download/version_15x/TeamViewer_Setup_x64.exe'
  checksum64    = 'fccef4dd9b654f98c100ab41a8e7e01d6257d496827caa740097e8a82e3e2054'
  checksumType64= 'sha256'

  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
