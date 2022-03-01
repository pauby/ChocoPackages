$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = 'vivaldi'
    fileType       = 'exe'

    url            = 'https://downloads.vivaldi.com/stable-auto/Vivaldi.5.1.2567.49.exe'
    url64bit       = 'https://downloads.vivaldi.com/stable-auto/Vivaldi.5.1.2567.49.x64.exe'

    checksum       = '928C93FB2FFD2D33B3CFD062054451404AB763180C3CF158949F1FDB4FA9D995'
    checksumType   = 'sha256'

    checksum64     = 'C1867D9181133E9F5403E58C84FD680B2FC52C8FC87240908371CC4A1D73B90D'
    checksumType64 = 'sha256'

    silentArgs     = '--vivaldi-silent --do-not-launch-chrome --system-level'
}

Install-ChocolateyPackage @packageArgs