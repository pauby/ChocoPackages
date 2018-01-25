$ErrorActionPreference = 'Stop';

$packageName = 'mysql-connector'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-6.10.6.msi'


$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'MSI'
    url            = $url

    softwareName   = 'mysql connector net*'

    checksum       = '372c900a891352f74e8e426bfa49a74948deef8a8ed829f5d4f83400d1869f8c'
    checksumType   = 'SHA256'

    silentArgs     = '/qn'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
