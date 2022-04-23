$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  softwareName  = 'TeamViewer*'

  url           = 'https://download.teamviewer.com/download/TeamViewer_Setup.exe'
  checksum      = 'f60062cf21ed42ba0adf64a296f124074ef4ad92b6b58e2f488c4b028a286bf4'
  checksumType  = 'sha256'

  url64         = 'https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe'
  checksum64    = 'efa1b635356ef73d7a61486ba89401b46cc7cf5a71f7d179beafe59152b2f8f6'
  checksumType64= 'sha256'

  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
