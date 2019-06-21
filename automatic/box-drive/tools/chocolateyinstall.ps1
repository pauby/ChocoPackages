$ErrorActionPreference = 'Stop'

$msiLogPath = ("{0}\{1}.{2}.MsiInstall.log" -f $env:TEMP, $env:chocolateyPackageName, $env:chocolateyPackageVersion)

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  url           = 'https://e3.boxcdn.net/box-installers/desktop/releases/win32/Box-x86.msi'
  checksum      = '9074be9a96594b868a4fd43383139574f47a20f00ff50996511b8cdf35ca08db'
  checksumType  = 'SHA256'

  url64         = 'https://e3.boxcdn.net/box-installers/desktop/releases/win/Box-x64.msi'
  checksum64    = 'CDEC74319D517DC044A96ADACD3C728AFA43A4B5093B5696527F93D0F60E573B'
  checksumType64= 'SHA256'

  softwareName  = 'box*'

  silentArgs    = "/quiet /norestart /l*v `"$msiLogPath`""
  validExitCodes= @(0)
}

# Check OS
if ([version](Get-WmiObject -Class Win32_OperatingSystem).version -lt [version]"10.0") {
  Write-Error "Box Drive ONLY supports Windows 10 (or later) or Windows Server 2016 (or later). Please use the Box Sync package (https://chocolatey.org/packages/boxsync) if you need support for earlier operating systems."
}

Install-ChocolateyPackage @packageArgs
Write-Verbose "Box Drive install log file is available at '$msiLogPath'"
