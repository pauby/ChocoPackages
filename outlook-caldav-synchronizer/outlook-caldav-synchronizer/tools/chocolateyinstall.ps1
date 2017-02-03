$ErrorActionPreference = 'Stop';

$packageName  = 'outlook-caldav-synchronizer'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = ''

#Based on NO DETECTION IN PRO
$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'outlook-caldav-synchronizer*'
  fileType      = 'zip'
  silentArgs    = "/qn" # NSIS
  #OTHERS
  # Uncomment matching EXE type (sorted by most to least common)
  #silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  #silentArgs   = '/s'           # InstallShield
  #silentArgs   = '/s /v"/qn"' # InstallShield with MSI
  #silentArgs   = '/s'           # Wise InstallMaster
  #silentArgs   = '-s'           # Squirrel
  #silentArgs   = '-q'           # Install4j
  #silentArgs   = '-s'           # Ghost
  # Note that some installers, in addition to the silentArgs above, may also need assistance of AHK to achieve silence.
  #silentArgs   = ''             # none; make silent with input macro script like AutoHotKey (AHK)
                                 #       https://chocolatey.org/packages/autohotkey.portable
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://sourceforge.net/projects/outlookcaldavsynchronizer/files/2.15.1/OutlookCalDavSynchronizer-2.15.1.zip/download"  #download URL, HTTPS preferrred
  checksum      = 'ECC386543E160328CFBB9B05B89A9D42F650960044627561450A16BC91C0EED1'
  checksumType  = 'sha256'
  url64bit      = ""   # 64bit URL here (HTTPS preferred) or remove - if installer contains both architectures (very rare), use $url
  checksum64    = ''
  checksumType64= 'sha256'
  destination   = $toolsDir
  file			= "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\CalDavSynchronizer.Setup.msi"
}

Install-ChocolateyZipPackage @packageArgs 
$packageArgs.fileType = 'msi'
Install-ChocolateyInstallPackage @packageArgs

## See https://chocolatey.org/docs/helpers-reference

