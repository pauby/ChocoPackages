$ErrorActionPreference = 'Stop'

# create temp directory
do {
    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
} while (Test-Path $tempPath)
New-Item -ItemType Directory -Path $tempPath | Out-Null

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $tempPath
  fileType      = 'MSI'
  url           = 'https://github.com//aluxnimm/outlookcaldavsynchronizer/releases/download/v3.2.0/OutlookCalDavSynchronizer-3.2.0.zip'

  checksum      = 'bb33e50b55f60f76540bb34d9904dfaec0539f890a8eb5eae7ad814b4fdbc7ec'
  checksumType  = 'SHA256'

  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
}

$arguments = Get-PackageParameters -Parameter $env:ChocolateyPackageParameters
if ($arguments.ContainsKey("allusers")) {
    $packageArgs.silentArgs += " ALLUSERS=1"
}

# Unzip the file to the tempPath and then install the MSI
Install-ChocolateyZipPackage @packageArgs

$packageArgs.file = Join-Path -Path $packageArgs.unzipLocation -ChildPath 'CalDavSynchronizer.Setup.msi'
Install-ChocolateyInstallPackage @packageArgs
