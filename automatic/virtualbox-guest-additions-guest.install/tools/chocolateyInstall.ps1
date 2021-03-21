$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$i = 0
do {
    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
    $i++
} while ((Test-Path -Path $tempPath) -and ($i -lt 100))

# check we've not hit the count limit
if ($i -ge 100) {
  Write-Error "We couldn't find a temp folder name to create! (count: $i)"
}

# Create the folder
$null = New-Item -ItemType Directory -Path $tempPath

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileFullPath   = Join-Path -Path $toolsDir -ChildPath 'VBoxGuestAdditions.iso'
  destination    = Join-Path -Path $tempPath -ChildPath 'extracted'
  fileType       = 'ZIP'
}

Get-ChocolateyUnzip @packageArgs

$binX86Filename = 'VBoxWindowsAdditions-x86.exe'
$binX64Filename = 'VBoxWindowsAdditions-amd64.exe'
$installArgs = @{
  packageName = $env:ChocolateyPackageName
  fileType = 'EXE'
  file = Join-Path -Path $packageArgs.destination -ChildPath $binX86Filename
  file64 = Join-Path -Path $packageArgs.destination -ChildPath $binX64Filename
  silentArgs = '/S'
  validExitCodes = @(0)
}

# certificate can be found inside the GPL version of virtualbox:
# https://www.virtualbox.org/svn/vbox/trunk/src/VBox/HostDrivers/Support/Certificates/Trusted-OracleCorporationVirtualBox-05308b76ac2e15b29720fb4395f65f38.cer
# current is expired 3/23/2022
$certFile = Join-Path -Path $toolsDir -ChildPath "Trusted-OracleCorporationVirtualBox-05308b76ac2e15b29720fb4395f65f38.cer"
certutil -addstore -f "TrustedPublisher" $certFile

Install-ChocolateyInstallPackage @installArgs
