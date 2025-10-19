$ErrorActionPreference = 'Stop'

$toolsDir = $(Split-Path -Parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'exe'
    url64           = 'https://installers.privateinternetaccess.com/download/pia-windows-x64-3.7-08412.exe'
    checksum64      = '0B3E64ADCBB0921C2E17669E61226690D7AC6C71ED5052E13D784287974AE451'
    checksumType64  = 'sha256'
}
Install-ChocolateyPackage @packageArgs
