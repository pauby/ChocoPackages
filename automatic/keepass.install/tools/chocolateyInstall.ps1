$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.38/KeePass-2.38-Setup.exe/download'
    checksum       = 'a5499b8b15d64f727c3c3f255cc443f3b1ae631a79da8c55711095e8a42afa57'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
