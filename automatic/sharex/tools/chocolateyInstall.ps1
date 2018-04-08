$ErrorActionPreference = 'Stop'

$packageName = 'sharex'
 
$packageArgs = @{
    packageName    = $packageName
    fileType       = 'exe'       
    url            = 'https://github.com/ShareX/ShareX/releases/download/v12.0.0/ShareX-12.0.0-setup.exe' 
    checksum       = 'DAC621553C23297569CF9B863C27D5B93B52DAA378257E8DC7B12E4C7E26EAFF'
    checksumType   = 'sha256'
    silentArgs     = '/sp /silent /norestart'
	validExitCodes = @(0)
}

Write-Host "If an older version of ShareX is running on this machine, it will be closed prior to the installation of the newer version."
Get-Process -Name sharex -ErrorAction SilentlyContinue | Stop-Process

Install-ChocolateyPackage @packageArgs