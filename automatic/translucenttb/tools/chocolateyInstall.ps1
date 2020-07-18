$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

if ([version](Get-WmiObject -Class Win32_OperatingSystem).version -lt [version]'10.0') {
    throw 'TranslucentTB ONLY supports Windows 10 (or later).'
}

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    file           = Join-Path -Path $toolsDir -ChildPath 'TranslucentTB-Setup_x32.exe'
    fileType       = 'EXE'
    silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG"
    validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs