$ErrorActionPreference = 'Stop'

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$logFilename = "{0}-{1}.log" -f $env:ChocolateyPackageName, $env:ChocolateyPackageVersion
$logPath     = Join-Path -Path $env:TEMP -ChildPath $logFilename

$packageArgs = @{
    PackageName    = $env:ChocolateyPackageName
    Url            = 'https://media.steampowered.com/steamlink/windows/latest/SteamLink.zip'
    UnzipLocation  = $toolsDir

    checksum       = '48E16CF4257170F0A6879336065B7DB8DA64ED587157FCC75B3888451C4929A9'
    checksumType   = 'SHA256'
}

Install-ChocolateyZipPackage @packageArgs

$installArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'MSI'
    file           = Join-Path -Path $toolsDir -ChildPath 'SteamLink.msi'

    silentArgs     = "/quiet /lv $logPath"
    validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @installArgs
