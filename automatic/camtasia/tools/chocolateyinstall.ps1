$ErrorActionPreference = 'Stop';

$packageName= 'camtasia'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Old Camtasia versions can be found at https://www.techsmith.com/download/oldversions
$url64      = 'https://download.techsmith.com/camtasiastudio/enu/1802/camtasia.msi'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url64bit      = $url64

  softwareName  = 'camtasia*'

  checksum64    = 'D4BF888A0B40B14AE89E05F20BBB1E00BB58172E2F23685C6838168E3898D2C7'
  checksumType64= 'SHA256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

write-debug "OS Name: $($env:OS_NAME)"
if ($env:OS_NAME -like "*Server*") {
    throw "Cannot be installed on a Server operating system ($($env:OS_NAME))."
}

$arguments = Get-PackageParameters -Parameter $env:chocolateyPackageParameters
foreach ($param in $arguments.Keys) {
    switch ($param) {
        "licensekey" {
            $licenseKey = $arguments["licensekey"]
            Write-Verbose "Parameter - License Key: $licenseKey"
            $packageArgs.silentArgs = "TSC_SOFTWARE_KEY=$licenseKey " + $packageArgs.silentArgs

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
    }
}

Install-ChocolateyPackage @packageArgs
