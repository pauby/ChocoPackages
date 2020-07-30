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

Install-ChocolateyInstallPackage @packageArgs

# Create shim ignore file(s)
Get-ChildItem -Path (Join-Path -Path $installDir -ChildPath '*.exe') | ForEach-Object {
    New-Item -Name "$($_.Name).ignore" -Path $installDir -ItemType File -ErrorAction SilentlyContinue | Out-Null
}
