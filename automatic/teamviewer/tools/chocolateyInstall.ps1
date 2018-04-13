$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url           = 'https://download.teamviewer.com/download/TeamViewer_Setup.exe'

  softwareName  = 'TeamViewer*'

  checksum      = 'f60062cf21ed42ba0adf64a296f124074ef4ad92b6b58e2f488c4b028a286bf4'
  checksumType  = 'sha256'

  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
