$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.38/KeePass-2.38-Setup.exe/download'
    checksum       = '400b66380d30c904711ba3b017aa97f9e67081b73d6a239c6c44ac2b663cb23b'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
