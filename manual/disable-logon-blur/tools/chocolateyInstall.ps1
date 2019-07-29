$ErrorActionPreference = 'Stop'

New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'System' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'DisableAcrylicBackgroundOnLogon' -PropertyType DWORD -Value 1 | Out-Null