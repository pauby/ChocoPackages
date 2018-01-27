$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.38/KeePass-2.38-Setup.exe/download'
    checksum       = '400B66380D30C904711BA3B017AA97F9E67081B73D6A239C6C44AC2B663CB23B'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
