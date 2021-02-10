$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'exe'
    silentArgs      = '/S /v/qn'
    file            = Join-Path -Path $toolsDir -ChildPath 'Windows_Tweaker_5.3.1-Setup.exe'
    validExitCodes  = @(0)
}

Install-ChocolateyInstallPackage @packageArgs