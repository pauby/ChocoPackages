$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'MSI'
    url            = 'https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-8.0.11.msi'

    softwareName   = 'mysql connector net*'

    checksum       = 'c66b1303a9a1e5a845b37cbcbf8f4dd1c63b9f1e039d60fb7c29e748bd3085f4'
    checksumType   = 'SHA256'

    silentArgs     = '/qn'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
