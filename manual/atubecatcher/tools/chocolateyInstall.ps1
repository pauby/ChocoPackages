$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = $env:ChocolateyPackageName
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'http://files.dsnetwb.com/aTube_Catcher.exe'

$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'EXE' #only one of these: exe, msi, msu
    url            = $url

    softwareName   = 'atube*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

    checksum       = '904A4623E5A150509C06972E4AA8D61E672C3FB38DBB70BCA4C2340E5B1E4635'
    checksumType   = 'SHA256' #default is md5, can also be sha1, sha256 or sha512

    silentArgs   = '/silent'
	validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs