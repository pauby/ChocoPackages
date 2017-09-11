$ErrorActionPreference = 'Stop';

$packageName = 'mysql-connector'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-6.9.9.msi'


$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'MSI'
    url            = $url

    softwareName   = 'mysql connector net*'

    checksum       = 'ffeeeb5b8b6089b1b64781ce40442dcea560c52ae98262c745783a1fca4b65eb'
    checksumType   = 'SHA256'

    silentArgs     = '/qn'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
