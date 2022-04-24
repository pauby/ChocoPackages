$ErrorActionPreference = 'Stop'

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$logFilename = "{0}-{1}.log" -f $env:ChocolateyPackageName, $env:ChocolateyPackageVersion
$logPath     = Join-Path -Path $env:TEMP -ChildPath $logFilename

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'MSI'
    url64           = 'https://edge.elgato.com/egc/windows/wavelink/1.4.1/WaveLink_1.4.1.2726_x64.msi'
    softwareName    = 'Elgato Wave Link'

    checksum64      = 'b66a0f39fc73060a6e3985c974afea1dc8b8110d040f1bb9ac25e23790760618'
    checksumType64  = 'SHA256'

    silentArgs      = "/quiet /lv $logPath"
    validExitCodes  = @(0, 3010, 1641)
}

# Check OS version
Write-Debug "OS Name: $($env:OS_NAME)"
if ($env:OS_NAME -ne "Windows 10") {
    Write-Warning "Wave Link is only supported on Windows 10 x64 and later. Installing it on any other operating system means you won't be supported by Elgato and your mileage may vary!"
}

Install-ChocolateyPackage @packageArgs