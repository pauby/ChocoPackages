$ErrorActionPreference = 'Stop'

$packageArgs = @{
    PackageName  = $env:ChocolateyPackageName
    VsixUrl      = 'https://github.com/adamdriscoll/poshtools/releases/download/v3.0.569/PowerShellTools.15.0.vsix'
    Checksum     = '4449B34B024E0177A6BB8F64319630167681602291562E98BC019E016839E1B6'
    ChecksumType = 'sha256'
}

Install-VisualStudioVsixExtension @packageArgs