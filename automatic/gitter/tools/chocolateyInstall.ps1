$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = Join-Path -Path $toolsDir -ChildPath $env:ChocolateyPackageName

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    file           = Get-Item -Path (Join-Path -Path $toolsDir -ChildPath '*_x32.exe')
    fileType       = 'EXE'
    silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR=$installDir"
    validExitCodes = @(0)
}

New-Item $installDir -ItemType Directory -ErrorAction SilentlyContinue
New-Item $installDir\notification_helper.exe.ignore -ItemType File -ErrorAction SilentlyContinue
New-Item $installDir\chromedriver.exe.ignore -ItemType File -ErrorAction SilentlyContinue
New-Item $installDir\nacl64.exe.ignore -ItemType File -ErrorAction SilentlyContinue
New-Item $installDir\nwjc.exe.ignore -ItemType File -ErrorAction SilentlyContinue
New-Item $installDir\payload.exe.ignore -ItemType File -ErrorAction SilentlyContinue

Install-ChocolateyInstallPackage @packageArgs