$ErrorActionPreference = 'Stop';

$packageName = 'mysql-connector'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-6.10.4.msi'


$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'MSI'
    url            = $url

    softwareName   = 'mysql connector net*'

    checksum       = '90e6d312b46c3519851e9100c40da356e7ecb06d189bcc80a2bed0c6fa7c8a16'
    checksumType   = 'SHA256'

    silentArgs     = '/qn'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
