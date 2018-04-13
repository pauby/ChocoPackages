$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'exe'       
    url            = 'https://github.com//ShareX/ShareX/releases/download/v12.1.1/ShareX-12.1.1-setup.exe' 
    checksum       = 'ee590a66234c0f1dc57725173eb4c4d3c1babf40c516b64e7d1604eb37f85909'
    checksumType   = 'SHA256'
    silentArgs     = '/sp /silent /norestart'
	validExitCodes = @(0)
}

Write-Host "If an older version of ShareX is running on this machine, it will be closed prior to the installation of the newer version."
Get-Process -Name sharex -ErrorAction SilentlyContinue | Stop-Process

Install-ChocolateyPackage @packageArgs
