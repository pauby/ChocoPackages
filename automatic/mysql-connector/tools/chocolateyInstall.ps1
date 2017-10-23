$ErrorActionPreference = 'Stop';

$packageName = 'mysql-connector'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-6.9.10.msi'


$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'MSI'
    url            = $url

    softwareName   = 'mysql connector net*'

    checksum       = '3e486cf82e67e9557825b122c0f62051513e56da675f6ab9d3fc0c58d416808f'
    checksumType   = 'SHA256'

    silentArgs     = '/qn'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
