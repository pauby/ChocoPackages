$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.39/KeePass-2.39-Setup.exe/download'
    checksum       = 'b61db93244b9594633d2e6854497c58076f93a26a0c8cbeb4d65f16ded74c578'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
