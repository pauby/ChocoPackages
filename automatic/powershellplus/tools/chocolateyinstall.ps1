$ErrorActionPreference = 'Stop'

do {
    $tempDir = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
} while (Test-Path $tempDir)
$null = New-Item -ItemType Directory -Path $tempDir

$zipArgs = @{
    packageName     = $env:ChocolateyPackageName
    unzipLocation   = $tempDir
    url             = 'http://downloadfiles.idera.com/products/IderaPowerShellPlusSetup-x86.zip'
    checksum        = 'f62522f296c8fcf41b96fbd4a66167d1313b533469c36927b9f210a08299bf71'
    checksumType    = 'SHA256'
    url64           = 'http://downloadfiles.idera.com/products/IderaPowerShellPlusSetup-x64.zip'
    checksum64      = '8de59eafa4a0d295c7be6b5cf733e24648d40b881592b142c5706c3732a5bb50'
    checksumType64  = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  file          = (Join-Path -Path $tempDir -ChildPath 'IderaPowerShellPlusSetup-x86.exe')
  file64        = (Join-Path -Path $tempDir -ChildPath 'IderaPowerShellPlusSetup-x64.exe')
  silentArgs   = '/s /v"/qn"'
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs
