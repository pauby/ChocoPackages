$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  softwareName  = 'TeamViewer*'

  url           = 'https://download.teamviewer.com/download/version_15x/TeamViewer_Setup.exe'
  checksum      = 'F2AA91FECCEA466BD9C0440DB1ADE6E16B10F42897E30431996FC4D02ED500F5'
  checksumType  = 'SHA256'

  url64         = 'https://download.teamviewer.com/download/version_15x/TeamViewer_Setup_x64.exe'
  checksum64    = 'dc205bbeb2e98ac474e816ae99ff993e263d8b7680777ad95dfb0eddaf38cfc4'
  checksumType64= 'sha256'

  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
