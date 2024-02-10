$ErrorActionPreference = 'Stop'
# chocolatey-misc-helpers.extension v0.0.4 (08-24-2020) by Bill Curran - public domain
# Creates a .pin file in \programdata\chocolatey\.chocolatey\packagename.packageversion folder to AutoPin a package
# Implementation should be via a user opt-in installation package parameter; i.e. AUTOPIN:YES
# REF: https://github.com/chocolatey/choco/issues/1607
# DISCLAIMER: Enable-AutoPin is implemented via an undocumented/non-public/unofficial "API." Tested with Chocolatey v0.10.11, should work with Chocolatey v0.9.9-v0.10.11. This will be deprecated when a future version of Chocolatey switches to using a database to store package options and thus this method will stop working. 

function Enable-AutoPin{
# 01-12-2019
# This function has been retired. Real world testing has shown that even though the function works perfectly, it's a negated as choco.exe
# deletes the .pin file after chocolateyinstall.ps1 finishes when the .pin file didn't exist previously. Even when the .pin file is set
# to read only, choco.exe errors out trying to delete the .pin file and fails the package install.
# -----> THWARTED! <-----
# Its existence is for backward compatibility, actual function NULLIFIED.
Write-Host "  ** The AutoPin function has been retired. It does not work. Please inform the package maintainer!" -ForeGround Red
return
if (Test-Path -Path $ENV:ChocolateyInstall\.chocolatey\$ENV:ChocolateyPackageName.$ENV:ChocolateyPackageVersion){
	New-Item -Path "$ENV:ChocolateyInstall\.chocolatey\$ENV:ChocolateyPackageName.$ENV:ChocolateyPackageVersion\" -ItemType "file" -Name ".pin" -Value "This package has been AutoPinned." -Force
	Out-File -FilePath "$ENV:ChocolateyInstall\.chocolatey\$ENV:ChocolateyPackageName.$ENV:ChocolateyPackageVersion\.pin" -InputObject "This package has been AutoPinned." -Force
	Set-ItemProperty -Path "$ENV:ChocolateyInstall\.chocolatey\$ENV:ChocolateyPackageName.$ENV:ChocolateyPackageVersion\.pin" -Name IsReadOnly -Value $true
   }
if (Test-Path -Path $ENV:ChocolateyInstall\.chocolatey\$ENV:ChocolateyPackageName.$ENV:ChocolateyPackageVersion\.pin){
    Write-Host "  ** $ENV:ChocolateyPackageName v$ENV:ChocolateyPackageVersion AutoPinned." -ForeGround Green
   } else {
     Write-Host "  ** Error creating AutoPin. Package NOT pinned." -ForeGround Red
   }
}
