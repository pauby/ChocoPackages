$ErrorActionPreference = 'Stop'
# chocolatey-misc-helpers.extension v0.0.4 (08-24-2020) by Bill Curran - public domain
# Show-PayPal.ps1 - Displays a message and link to your PayPal account, i.e. www.paypal.me/account
# If you define $global:packageMaintainer in your chocolateyinstall.ps1, 
# i.e. $global:packageMaintainer = 'BCURRAN3' it will use that too.
# Recommended to run this right before Install-ChocolateyPackage - that's when you MIGHT have a moment of the user's attention.
# Oh yeah! You can donate to me at https://www.paypal.me/bcurran3donations :)

function Show-PayPal($PayPalURL){
# 08-24-2018
# This function has been disallowed by the Chocolatey team. Donation requests can be on package pages but not in packages. :( Hey fellow maintainers, I tried!
# Its existence is for backward compatibility, actual function NULLIFIED.
Write-Host "  ** The Show-PayPal function has been retired. Please inform the package maintainer!" -ForeGround Red
return

Write-Host "-- While you're waiting for your package to install, consider donating to" -foreground cyan
if ($packageMaintainer) {
    Write-Host "-- $packageMaintainer, the maintainer of this $env:packageName package, at $PayPalURL" -foreground cyan
   } else {
    Write-Host "-- the maintainer of this $env:packageName package at $PayPalURL" -foreground cyan
   }
}
