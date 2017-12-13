$ErrorActionPreference = 'Stop';

$packageName = 'acr'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com//acreloaded/acr/releases/download/v2.6.3/acr_02_06_03-w.zip'
$executable = "client.bat"

$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    url            = $url

    softwareName   = 'acr*'

    checksum       = '522163f665802d2b38c58cad3bddb98f4a236b6e8927bc7c179c82a19cd63db2'
    checksumType   = 'SHA256'

    validExitCodes = @(0)
}

Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyShortcut -ShortcutFilePath (Join-Path -Path $env:ALLUSERSPROFILE -ChildPath "Microsoft\Windows\Start Menu\Programs\AC Reloaded.lnk") `
	-TargetPath (Join-Path -Path $packageArgs.unzipLocation -ChildPath $executable) `
	-WorkingDirectory $toolsdir
