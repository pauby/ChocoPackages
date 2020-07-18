$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    file           = Join-Path -Path $toolsDir -ChildPath 'TranslucentTB-Setup_x32.exe'
    fileType       = 'EXE'
    silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG"
    validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs