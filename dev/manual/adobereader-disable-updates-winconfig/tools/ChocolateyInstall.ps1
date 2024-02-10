$ErrorActionPreference = 'Stop'
$packageName = 'adobereader-disable-updates-winconfig'

SchTasks /Change /Disable /TN "Adobe Acrobat Update Task" | Out-Null
Stop-Service "AdobeARMservice" -force | Out-Null
Set-Service "AdobeARMservice" -StartupType Disabled | Out-Null

Write-Host "  ** Adobe Reader and Acrobat Manager (ARM) disabled." -foreground magenta
Write-Host "  ** Adobe Reader will only be updated by Chocolatey." -foreground magenta
