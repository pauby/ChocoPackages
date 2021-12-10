$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Old Techsmith software versions can be found at https://www.techsmith.com/download/oldversions
$url64 = 'https://download.techsmith.com/snagit/releases/2200/snagit.exe'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url64bit       = $url64

    checksum64     = '3159669d04f6229ee4399ec607771fd48aeff0dbb9be66a806defbb3e9ed8209'
    checksumType64 = 'sha256'

    silentArgs     = "/S " # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
    validExitCodes = @(0, 3010)
}

$arguments = Get-PackageParameters -Parameter $env:chocolateyPackageParameters
# use licensekey instead of licenseCode as this is consistent with Camtasia
if ($arguments.ContainsKey('licenseCode')) {
    if (-not ($arguments.ContainsKey('licensekey'))) {
        # create licensekey key with licenseCode value
        $arguments.licensekey = $arguments.licenseCode
    }
    $arguments.Remove('licenseCode')
}

# parameters taken from the Snagit MSI doc (they work with the EXE)
# https://assets.techsmith.com/Docs/Snagit-2022-MSI-Installation-Guide.pdf
# See 'Customization with a Third-Party Tool (Advanced)' section (valid in 2022 version)
foreach ($param in $arguments.Keys) {
    switch ($param) {
        "licensekey" {
            $licenseKey = $arguments["licensekey"]
            Write-Verbose "Parameter - License Key: $licenseKey"
            $packageArgs.silentArgs = "TSC_SOFTWARE_KEY=$licenseKey " + $packageArgs.silentArgs

            # this hasn't been supported for a while not
            if ($arguments.ContainsKey("licensename")) {
                $licenseName = $arguments["licensename"]
                Write-Verbose "Parameter - License Name: $licenseName"
                $packageArgs.silentArgs = "TSC_SOFTWARE_USER=$licenseName " + $packageArgs.silentArgs
            }
        }

        "nodesktopshortcut" {
            Write-Verbose "Parameter - Desktop Shortcut: Disabled"
            $packageArgs.silentArgs = "TSC_DESKTOP_LINK=0 " + $packageArgs.silentArgs
        }

        "installdir" {
            Write-Verbose "Parameter - Install directory: $($arguments['installdir'])"
            $packageArgs.silentArgs += "INSTALLDIR=$($arguments['installdir']) "
        }

        "disableautostart" {
            Write-Verbose "Parameter - Run when Windows Starts: Disabled"
            $packageArgs.silentArgs += "TSC_START_AUTO=0 "
        }

        "datastoredir" {
            Write-Verbose "Parameter - Path to save auotmatically stored path: $($arguments['datastoredir'])"
            $packageArgs.silentArgs += "TSC_DATA_STORE_LOCATION=$($arguments['datastoredir']) "
        }

        "appdatadir" {
            Write-Verbose "Parameter - Path to store user preferences and user released data files: $($arguments['appdatadir'])"
            $packageArgs.silentArgs += "TSC_APP_DATA_PATH=$($arguments['appdatadir']) "
        }
    }
}

Install-ChocolateyPackage @packageArgs
