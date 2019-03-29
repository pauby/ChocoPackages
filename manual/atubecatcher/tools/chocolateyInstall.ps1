$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = 'http://files.dsnetwb.com/aTube_Catcher.exe'

    checksum       = '5AC711FB525EBDED5649240F83B596F992CB17EE4725A356B795EFF6C2D17271'
    checksumType   = 'SHA256' #default is md5, can also be sha1, sha256 or sha512

    silentArgs   = '/silent'
	validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs