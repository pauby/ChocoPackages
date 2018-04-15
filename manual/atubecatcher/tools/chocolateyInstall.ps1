$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = 'http://files.dsnetwb.com/aTube_Catcher.exe'

    checksum       = 'A6976364942431A09A925AA93D8EBA0AF339903D7E0253B1A4D4922363A7D6D3'
    checksumType   = 'SHA256' #default is md5, can also be sha1, sha256 or sha512

    silentArgs   = '/silent'
	validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs