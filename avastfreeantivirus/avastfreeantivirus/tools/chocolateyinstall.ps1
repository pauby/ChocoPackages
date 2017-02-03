
$ErrorActionPreference = 'Stop';


$packageName= 'avastfreeantivirus'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://files.avast.com/iavs9x/avast_free_antivirus_setup.exe'
$url64      = ''

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64

  softwareName  = 'avastfreeantivirus*'

  checksum      = '4A30F70BB12C0701B47C8352B997BD51309EFED8E6EBD61970FCD1ADF2452337'
  checksumType  = 'sha256'
  checksum64    = '4A30F70BB12C0701B47C8352B997BD51309EFED8E6EBD61970FCD1ADF2452337'
  checksumType64= 'sha256'

  silentArgs    = "/silent"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs


















