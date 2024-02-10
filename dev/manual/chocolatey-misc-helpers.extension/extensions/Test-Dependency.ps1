$ErrorActionPreference = 'Stop'
# chocolatey-misc-helpers.extension v0.0.4 (08-24-2020) by Bill Curran - public domain
# Tests to verify a dependency is installed and returns true/false. Does NOT check version. 
# Designed for use with my OS dependency packages but can be used for anything to verify that SOME VERISION 
# of the dependency is installed; i.e. Chocolatey v0.10.11 will continue trying to install a package even
# if the dependency fails installation. Using Test-Dependency you can verify the dependency package DID get 
# installed and abort if not. Example: Test-Dependency "dependency-windows10"
# You would typically run this sometime before Install-ChocolateyPackage

function Test-Dependency($dependency){
if (Test-Path -Path $env:ChocolateyInstall\lib\$dependency){
    return $True
	Write-Host "  ** Dependency $dependency found." -ForeGround Green
    } else {
	  return $False
	  Write-Host "  ** Dependency $dependency NOT found." -ForeGround Red
    }
}
