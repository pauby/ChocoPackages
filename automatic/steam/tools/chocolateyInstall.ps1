$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe'
    checksum       = '029F918A29B2B311711788E8A477C8DE529C11D7DBA3CAF99CBBDE5A983EFDAD'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    # the setup spawns installer.exe to do the installation and exits with 2 for some reason.
    # it's a weird installer
    validExitCodes = @(0)   
}

Install-ChocolateyPackage @packageArgs