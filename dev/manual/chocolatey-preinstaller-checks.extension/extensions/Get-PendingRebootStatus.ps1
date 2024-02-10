$ErrorActionPreference = 'Stop'
# chocolatey-preinstaller-checks.extension v0.0.2 by Bill Curran AKA BCURRAN3 - 2018 Copyleft Bill Curran
# Get-PendingRebootStatus.ps1 - warns if Windows has a pending reboot
# See/Edit Chocolatey-Preinstaller-Checks.xml for options
# If this extension stops your packages from becoming lost and unmanaged, consider becoming a patron of me at https://www.patreon.com/bcurran3 :)

function Get-PendingRebootStatus{
# thanks to http://ilovepowershell.com/2015/09/10/how-to-check-if-a-server-needs-a-reboot/

$RebootStatus=$false
if (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue) { $RebootStatus=$true }
if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) { $RebootStatus=$true }
if (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -ErrorAction SilentlyContinue) { $RebootStatus=$true }
 try { 
   $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
   $status = $util.DetermineIfRebootPending()
   if(($status -ne $null) -and $status.RebootPending){
     RebootStatus=$true
   }
 }catch{}

if ($RebootStatus -eq $true){
     Write-Host "  * WARNING: Pending reboot found." -foreground red 
   } else {
     Write-Host "  * Pending reboot NOT found." -foreground green
   }
}
