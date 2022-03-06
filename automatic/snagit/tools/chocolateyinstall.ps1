$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Old Techsmith software versions can be found at https://www.techsmith.com/download/oldversions
$url64 = ''
$checksum64 = ''
$checksumType64 = 'SHA256'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url64bit       = $Url64

    checksum64     = $checksum64
    checksumType64 = $checksumType64

    silentArgs     = '/quiet /passive /norestart'
    validExitCodes = @(0, 3010, 1641)
}

$arguments = Get-PackageParameters -Parameter $env:chocolateyPackageParameters
# use licensekey instead of licenseCode as this is consistent with Snagit
if ($arguments.ContainsKey('licenseCode')) {
    if (-not ($arguments.ContainsKey('licensekey'))) {
        # create licensekey key with licenseCode value
        $arguments.licensekey = $arguments.licenseCode
    }
    $arguments.Remove('licenseCode')
}

foreach ($param in $arguments.Keys) {
    switch ($param) {
        "licensekey" {
            $licenseKey = $arguments["licensekey"]
            Write-Verbose "Parameter - License Key: $licenseKey"
            $packageArgs.silentArgs = "TSC_SOFTWARE_KEY=$licenseKey " + $packageArgs.silentArgs
        }
    }
}

Install-ChocolateyPackage @packageArgs
