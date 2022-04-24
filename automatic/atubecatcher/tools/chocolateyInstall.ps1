$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = 'https://files.dsnetwb.com/aTube_Catcher_FREE_9961.exe'

    checksum       = '9F340A8DD6ED01B9C021D0DE77BD8F50161676E54E3600A40591D6E97E46C4E5'
    checksumType   = 'SHA256' #default is md5, can also be sha1, sha256 or sha512

    silentArgs   = '/silent'
	validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
