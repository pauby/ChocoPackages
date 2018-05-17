$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://github.com//source-foundry/Hack-windows-installer/releases/download/v1.6.0/HackFontsWindowsInstaller.exe'
    checksum       = 'a408b54d3b08f9a120574a6da1f1c6bbf2af7e9803c50da49ef13090f5edcc67'
    checksumType   = 'sha256'
    fileType       = 'EXE'
    silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /NORESTARTAPPLICATIONS"
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
