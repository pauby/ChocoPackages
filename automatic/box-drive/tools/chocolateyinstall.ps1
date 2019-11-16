$ErrorActionPreference = 'Stop'

$msiLogPath = ("{0}\{1}.{2}.MsiInstall.log" -f $env:TEMP, $env:chocolateyPackageName, $env:chocolateyPackageVersion)

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  url           = 'https://e3.boxcdn.net/box-installers/desktop/releases/win32/Box-x86.msi'
  checksum      = 'ad821bbfd5ec96f12347d8c66d011130c9f7b2ac3b741f53e9f29ee422225cac'
  checksumType  = 'SHA256'

  url64         = 'https://e3.boxcdn.net/box-installers/desktop/releases/win/Box-x64.msi'
  checksum64    = '71EC4AA30FB74D425C02725C4EA77319D0E62CBC810F6F4D05D0B776811121D3'
  checksumType64= 'SHA256'

  softwareName  = 'box'

  silentArgs    = "/quiet /norestart /l*v `"$msiLogPath`""
  validExitCodes= @(0)
}

# Check OS
if ([version](Get-WmiObject -Class Win32_OperatingSystem).version -lt [version]"10.0") {
  Write-Error "Box Drive ONLY supports Windows 10 (or later) or Windows Server 2016 (or later). Please use the Box Sync package (https://chocolatey.org/packages/boxsync) if you need support for earlier operating systems."
}

# Box Drive is not compatible with Box Sync so check if that is installed first
if (Get-UninstallRegistryKey -SoftwareName 'box sync') {
  Write-Warning "Box Drive cannot be installed while Box Sync is installed. Please remove it before installing Box Drive."
  Write-Warning "See 'Windows Prerequisites' on the 'Installing and Updating Box Drive' page (https://community.box.com/t5/Getting-Started-with-Box-Drive/Installing-and-Updating-Box-Drive/ta-p/37450)"
  throw "Box Drive cannot be installed while Box Sync is installed."
}

# check if Box Drive is already installed
if (Get-UninstallRegistryKey -SoftwareName 'box') {
  Write-Warning "Box Drive automatically updates itself. As it is already installed we will not try to install it again as this will result in an error due to the way the installer works."
  Write-Warning "If you are trying to force install this package please uninstall and install it again."
}
else {
  Install-ChocolateyPackage @packageArgs
  Write-Verbose "Box Drive install log file is available at '$msiLogPath'"
}