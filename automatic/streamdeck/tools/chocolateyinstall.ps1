$ErrorActionPreference = 'Stop'

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$logFilename = "{0}-{1}.log" -f $env:ChocolateyPackageName, $env:ChocolateyPackageVersion
$logPath     = Join-Path -Path $env:TEMP -ChildPath $logFilename

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'MSI'
    url64           = 'https://edge.elgato.com/egc/windows/sd/Stream_Deck_5.2.0.14948.msi'
    softwareName    = 'Elgato Stream Deck'

    checksum64      = 'd0940e4796c18de7a9747d205dd8a7929d4f9664ec88e052f61872b394fbba40'
    checksumType64  = 'SHA256'

    silentArgs      = "/quiet /lv $logPath"
    validExitCodes  = @(0, 3010, 1641)
}

# Check OS version
Write-Debug "OS Name: $($env:OS_NAME)"
if ($env:OS_NAME -ne "Windows 10") {
    Write-Warning "Stream deck is only supported on Windows 10 x64 and later. Installing it on any other operating system means you won't be supported by Elgato and your mileage may vary!"
}

Install-ChocolateyPackage @packageArgs
