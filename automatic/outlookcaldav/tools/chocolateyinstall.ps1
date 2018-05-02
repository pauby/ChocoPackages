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
  url           = 'https://github.com//aluxnimm/outlookcaldavsynchronizer/releases/download/v3.1.1/OutlookCalDavSynchronizer-3.1.1.zip'

  checksum      = '996f396c691c1505f7d542a7a01a41f72771f37973e5a3f5277b908a6cb6ed27'
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
