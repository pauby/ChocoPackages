$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = 'https://github.com//aluxnimm/outlookcaldavsynchronizer/releases/download/v3.1.0/OutlookCalDavSynchronizer-3.1.0.zip'
  file          = Join-Path -Path $toolsDir -ChildPath 'CalDavSynchronizer.Setup.msi'

  checksum      = 'f4144f93a5157ef894b8f7a2ceb4a8cbfa5e6ab23c4ac93b5b8678c5487e09e1'
  checksumType  = 'SHA256'

  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
}

$arguments = Get-PackageParameters -Parameter $env:ChocolateyPackageParameters
if ($arguments.ContainsKey("allusers")) {
    $packageArgs.silentArgs += " ALLUSERS=1"
}

# Unzip the file to the toolsdir and then install the MSI
Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs

# Create a shim ignore
New-Item -Name 'setup.exe.ignore' -Path $toolsDir -ItemType File -ErrorAction SilentlyContinue | Out-Null