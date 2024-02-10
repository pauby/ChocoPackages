$ErrorActionPreference = 'Stop'
# chocolatey-preinstaller-checks.extension v0.0.2 by Bill Curran AKA BCURRAN3 - 2018 Copyleft Bill Curran
# Start-PreuninstallChecks.ps1 - aliased as Uninstall-ChocolateyPackage to intercept and run before Uninstall-ChocolateyPackage then returns original functionality and passes on to uninstall the package
# See/Edit Chocolatey-Preinstaller-Checks.xml for options
# If this extension stops your packages from becoming lost and unmanaged, consider becoming a patron of mine at https://www.patreon.com/bcurran3 :)

function Start-PreuninstallChecks{
Write-Host "PRE-UNINSTALLATION CHECKS:" -foreground magenta
Get-PendingRebootStatus
Get-WindowsInstallerStatus
Get-chocoStatus
if ($global:CPCEAbort -eq $true){ throw }

# support for chocolatey-toast-notifications.extension 
if (Get-Command Uninstall-ChocolateyPackageWithToastNotification -ErrorAction SilentlyContinue){
   return
  } else {
    # Remove alias for normal operations and call Uninstall-ChocolateyPackage actual
    Remove-Item alias:\Uninstall-ChocolateyPackage
	Uninstall-ChocolateyPackage @args
   }
}
