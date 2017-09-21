$ErrorActionPreference = 'Stop';

$packageName = 'gitter'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://update.gitter.im/win/GitterSetup-3.1.0.exe'

$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'EXE'
    url            = $url

    softwareName   = 'Gitter'
    checksum       = '897c7a0e2b45f57c2e2651b7cca795f681407378d5974d3694dfd986070fca7b'
    checksumType   = 'sha256'

    silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR=$env:chocolateyPackageFolder"

    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

# Start Menu shortcuts are created under the admin account - move them to All Users start menu
Move-Item -Path (Join-Path -Path $env:USERPROFILE -ChildPath "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Gitter") `
	-Destination (Join-Path -Path $env:ALLUSERSPROFILE -ChildPath "Microsoft\Windows\Start Menu\Programs") -Force
