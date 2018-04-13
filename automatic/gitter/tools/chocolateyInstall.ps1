$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://update.gitter.im/win/GitterSetup-3.1.0.exe'
    checksum       = '897c7a0e2b45f57c2e2651b7cca795f681407378d5974d3694dfd986070fca7b'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR=$env:chocolateyPackageFolder"
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

# Create a shim ignore file ignore
New-Item -Name 'gitter.exe.ignore' -Path (Split-Path -Path $toolsDir -Parent) -ItemType File -ErrorAction SilentlyContinue

# Start Menu shortcuts are created under the admin account - move them to All Users start menu
Move-Item -Path (Join-Path -Path ([Environment]::GetFolderPath('Programs')) -ChildPath 'Gitter') `
    -Destination ([Environment]::GetFolderPath('CommonPrograms')) -Force
