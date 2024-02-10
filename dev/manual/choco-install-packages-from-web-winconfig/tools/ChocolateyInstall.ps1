$ErrorActionPreference = 'Stop'
$packageName = 'choco-install-packages-from-web-winconfig'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Delete old association from v0.0.1
Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\" -Name "$env:ChocolateyInstall\bin\cinst.exe" -ea SilentlyContinue | Out-Null
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.nupkg" -Recurse –Force -ea SilentlyContinue | Out-Null
Remove-Item -Path "HKCU:nupkg_auto_file" -Recurse –Force -ea SilentlyContinue | Out-Null

# Set Windows to auto-run .nupkg files with choco-install-packages-from-web-winconfig.cmd
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
New-Item -Path "HKCR:\" -Name ".nupkg" –Force | Out-Null
Set-ItemProperty -Path "HKCR:\.nupkg"-Name "(Default)" -Value "nupkg_auto_file"
New-Item -Path "HKCR:\" -Name "nupkg_auto_file" –Force | Out-Null
New-Item -Path "HKCR:\nupkg_auto_file" -Name "shell" –Force | Out-Null
New-Item -Path "HKCR:\nupkg_auto_file\shell" -Name "open" –Force | Out-Null
New-Item -Path "HKCR:\nupkg_auto_file\shell\open" -Name "command" –Force | Out-Null
Set-ItemProperty -Path "HKCR:\nupkg_auto_file\shell\open\command" -Name "(Default)" -Value """$env:ChocolateyInstall\lib\choco-install-packages-from-web-winconfig\tools\choco-install-packages-from-web-winconfig.cmd %1""" -Force


New-Item -Path "HKCU:\" -Name "\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.nupkg" –Force | Out-Null
New-Item -Path "HKCU:\" -Name "\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.nupkg\OpenWithList" –Force | Out-Null
New-Item -Path "HKCU:\" -Name "\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.nupkg\OpenWithList\a" –Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.nupkg\OpenWithList" -Name "a" -Value """$env:ChocolateyInstall\lib\choco-install-packages-from-web-winconfig\tools\choco-install-packages-from-web-winconfig.cmd %1""" -Force