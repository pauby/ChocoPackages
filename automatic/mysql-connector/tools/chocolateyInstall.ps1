$ErrorActionPreference = 'Stop';

$packageName = 'mysql-connector'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-6.10.5.msi'


$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'MSI'
    url            = $url

    softwareName   = 'mysql connector net*'

    checksum       = '28e025d89f743f7ad707d0e7f2cc04441e1c4572eb5e00c9c02ea8ed48f6253a'
    checksumType   = 'SHA256'

    silentArgs     = '/qn'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
