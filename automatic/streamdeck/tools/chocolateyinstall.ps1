$ErrorActionPreference = 'Stop'

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$logFilename = "{0}-{1}.log" -f $env:ChocolateyPackageName, $env:ChocolateyPackageVersion
$logPath     = Join-Path -Path $env:TEMP -ChildPath $logFilename

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'MSI'
    url64           = 'https://edge.elgato.com/egc/windows/sd/Stream_Deck_4.5.0.12226.msi'
    softwareName    = 'Elgato Stream Deck'

    checksum64      = '87E8959DBE10A6218B7B2B1CA7B1CA58E78FB7EA3696E1F8DEC8D5E9F60C731B'
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