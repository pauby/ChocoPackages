$ErrorActionPreference = 'Stop'

$toolsDir = $(Split-Path -Parent $MyInvocation.MyCommand.Definition)

# Not supported on Server OS's but can be installed.
if ($env:OS_NAME -like "*Server*") {
    Write-Warning "The software is only supported on Windows 10 and Windows 11, and not on Windows Server operating systems."
    Write-Warning "See the Windows downlaod page at https://www.privateinternetaccess.com/download/windows-vpn"
    throw
}

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'exe'
    url64           = 'https://installers.privateinternetaccess.com/download/pia-windows-x64-3.7-08412.exe'
    checksum64      = '0B3E64ADCBB0921C2E17669E61226690D7AC6C71ED5052E13D784287974AE451'
    checksumType64  = 'sha256'
}
Install-ChocolateyPackage @packageArgs
