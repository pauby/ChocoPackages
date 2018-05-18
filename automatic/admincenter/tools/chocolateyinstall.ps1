
$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'MSI'
    url            = 'https://aka.ms/WACDownload'
    checksum       = '3F49AD90CA3BBCA3147B1DF4E5C55E1A8B44BBAEF8F6DFA05BA8CF1AE0D2089E'
    checksumType   = 'SHA256'
    silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" SME_PORT=6516 SSL_CERTIFICATE_OPTION=generate"
    validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
