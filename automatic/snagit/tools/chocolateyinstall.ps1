$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Old Techsmith software versions can be found at https://www.techsmith.com/download/oldversions
$url64 = 'https://download.techsmith.com/snagit/releases/2202/snagit.msi'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url64bit       = $Url64

    checksum64     = '13bbc06aa468b05f7d58ff192b3f4c0c32e2004a4cbd505bd534deb772396126'
    checksumType64 = 'sha256'

    silentArgs     = '/quiet /passive /norestart'
    validExitCodes = @(0, 3010, 1641)
}

# Snagit MSI parameters https://assets.techsmith.com/Docs/Snagit-2022-MSI-Installation-Guide.pdf
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
        "Licensekey" {
            $licenseKey = $arguments["licensekey"]
            Write-Verbose "Parameter - License Key: $licenseKey"
            $packageArgs.silentArgs = "TSC_SOFTWARE_KEY=$licenseKey " + $packageArgs.silentArgs
        }

        'NoDesktopShortcut' {
            Write-Verbose "Parameter - Desktop Shortcut: Disabled (note Snagit no longer creates a desktop icon by default so this option no longer does anything)."
        }

        'DisableAutoStart' {
            Write-Verbose "Parameter - Autostart with Windows: false"
            $packageArgs.silentArgs = "TSC_START_AUTO=0 " + $packageArgs.silentArgs
        }

        'DisableStartNow' {
            Write-Verbose "Parameter - Start after installation: false"
            $packageArgs.silentArgs = "START_NOW=0 " + $packageArgs.silentArgs
        }

        'Language' {
            $validLanguage = @( 'ENU', 'DEU', 'ESP', 'FRA', 'JPN', 'PTB' )
            if ($arguments['language'] -in $validLanguage) {
                Write-Verbose "Parameter - Application Language: $($arguments['language'])"
                $packageArgs.silentArgs = "TSC_APP_LANGUAGE=$($arguments['language']) " + $packageArgs.silentArgs
            }
            else {
                Write-Error "Parameter - Application Language is invalid. Valid languages are $($validLanguage -join ', ')."
            }
        }

        'HideRegistrationKey' {
            Write-Verbose "Parameter - Hide registration key: true"
            $packageArgs.silentArgs = "TSC_HIDE_REGISTRATION_KEY=1 " + $packageArgs.silentArgs
        }
    }
}

Install-ChocolateyPackage @packageArgs
