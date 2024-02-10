$ErrorActionPreference = 'Stop'
$packageName = 'adobereader-disable-updates-winconfig'

SchTasks /Change /Enable /TN "Adobe Acrobat Update Task" | Out-Null
Set-Service "AdobeARMservice" -StartupType Automatic | Out-Null
Start-Service "AdobeARMservice" | Out-Null

Write-Host "  ** Adobe Reader and Acrobat Manager (ARM) re-enabled." -foreground magenta
Write-Host "  ** Adobe Reader will be updated by Adobe Reader and Acrobat Manager (ARM) and Chocolatey." -foreground magenta
