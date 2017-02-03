$ErrorActionPreference = 'Stop';

$packageName  = 'yubikey-neo-manager'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = ''

#Based on NO DETECTION IN PRO
$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'yubikey-neo-manager*'
  fileType      = 'exe'
  silentArgs    = "/S" # NSIS
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
  url           = "https://developers.yubico.com/yubikey-neo-manager/Releases/yubikey-neo-manager-1.4.0-win.exe"  #download URL, HTTPS preferrred
  checksum      = 'D7D03379AF80AE15487106C685DCEACF1851D6D4D59BDE29117C42B9B83167E2'
  checksumType  = 'sha256'
  url64bit      = ""   # 64bit URL here (HTTPS preferred) or remove - if installer contains both architectures (very rare), use $url
  checksum64    = ''
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 

## See https://chocolatey.org/docs/helpers-reference

