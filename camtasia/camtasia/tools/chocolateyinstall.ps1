$ErrorActionPreference = 'Stop';

$packageName= 'camtasia'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$urlVer 	= ($env:ChocolateyPackageVersion).Replace(".","")	# remove the '.' from the version number and use that in the download URL
$url64      = "https://download.techsmith.com/camtasiastudio/enu/$urlVer/camtasia.msi"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url64bit      = $url64

  softwareName  = 'camtasia*'

  checksum64    = '2EAD499EC58CC0FAD9283A079D8D79EC62E8BC2FA31F61026AC83F36E9BACE56'
  checksumType64= 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

. "$toolsDir\PSPackageExtensions.ps1"
write-debug "OS Name: $($env:OS_NAME)"
if (Test-ChocoServerOS) {
    throw "Cannot be installed on a Server operating system ($($env:OS_NAME))."
}

$arguments = ConvertFrom-ChocoParameters -Parameter $env:chocolateyPackageParameters
foreach ($param in $arguments.Keys) {
    switch ($param) {
        "licensekey" {
            $licenseKey = $arguments["licensekey"]
            Write-Warning "Parameter - License Key: $licenseKey"
            $packageArgs.silentArgs = "TSC_SOFTWARE_KEY=$licenseKey " + $packageArgs.silentArgs

            if ($arguments.ContainsKey("licensename")) {
                $licenseName = $arguments["licensename"]
                Write-Warning "Parameter - License Name: $licenseName"
                $packageArgs.silentArgs = "TSC_SOFTWARE_USER=$licenseName " + $packageArgs.silentArgs
            }
        }

        "nodesktopshortcut" {
            Write-Warning "Parameter - Desktop Shortcut: Disabled"
            $packageArgs.silentArgs = "TSC_DESKTOP_LINK=0 " + $packageArgs.silentArgs
        }
    }
}

Install-ChocolateyPackage @packageArgs