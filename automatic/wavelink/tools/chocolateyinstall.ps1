$ErrorActionPreference = 'Stop'

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$logFilename = "{0}-{1}.log" -f $env:ChocolateyPackageName, $env:ChocolateyPackageVersion
$logPath     = Join-Path -Path $env:TEMP -ChildPath $logFilename

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    fileType        = 'MSI'
    url64           = 'https://edge.elgato.com/egc/windows/wavelink/1.5.0/WaveLink_1.5.0.2889_x64.msi'
    softwareName    = 'Elgato Wave Link'

    checksum64      = '57315287d516d21d587945cf986233ef4b70833a9b5e534b50c0c7c89a643ed6'
    checksumType64  = 'SHA256'

    silentArgs      = "/quiet /lv $logPath"
    validExitCodes  = @(0, 3010, 1641)
}

# Check OS version
Write-Debug "OS Name: $($env:OS_NAME)"
Write-Debug "OS Version $($env:OS_Version)"
if ($env:OS_NAME -ne "Windows 10" -and [version]$env:OS_VERSION -lt [version]"10.0.1607") {
    throw "Wave Link is only supported on Windows 10 x64 Anniversary Edition (1607) and later."
}

Install-ChocolateyPackage @packageArgs
