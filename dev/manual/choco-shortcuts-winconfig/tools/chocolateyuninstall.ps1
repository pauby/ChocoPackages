$ErrorActionPreference = 'Stop'
$packageName  = 'choco-shortcuts-winconfig' # v0.0.3

# Create new icon for Choco Cleaner in Start Menu root if installed
# https://community.chocolatey.org/packages/choco-cleaner
$shortcutName     = 'Chocolatey Cleaner.lnk'
if (Test-Path $env:ChocolateyInstall\bin\choco-cleaner.bat){
	$ChocoCommand = "/c %ChocolateyInstall%\bin\choco-cleaner.bat && pause"
    Install-ChocolateyShortcut -shortcutFilePath "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -targetPath $env:ComSpec -Arguments $ChocoCommand -IconLocation $env:ChocolateyInstall\lib\choco-cleaner\tools\choco-cleaner.ico -RunAsAdmin
   }

# Create new icon for Chocolatey Package List Backup in Start Menu root if installed
# https://community.chocolatey.org/packages/choco-package-list-backup
$shortcutName    = 'Chocolatey Package List Backup.lnk'
if (Test-Path "$env:ChocolateyInstall\bin\choco-package-list-backup.bat"){
	$ChocoCommand = "/c %ChocolateyInstall%\bin\choco-package-list-backup.bat && pause"
	Install-ChocolateyShortcut -shortcutFilePath "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -targetPath $env:ComSpec -Arguments $ChocoCommand -IconLocation $env:ChocolateyInstall\choco.exe -RunAsAdmin
   }	

# Create new icon for ChocolateyPowerShell in Start Menu root if installed
# https://community.chocolatey.org/packages/chocolateypowershell
$shortcutName = 'ChocolateyPowerShell.lnk'
if (Test-Path "$env:ChocolateyInstall\lib\chocolateypowershell"){
    Install-ChocolateyShortcut -shortcutFilePath "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -targetPath "$env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe" -Arguments "-noexit -c $env:ChocolateyInstall\lib\chocolateypowershell\tools\ChocolateyEnvironment.ps1" -WorkingDirectory "$env:SystemDrive\" -IconLocation "$env:ChocolateyInstall\lib\chocolateypowershell\tools\chocolateypowershell.ico" -RunAsAdmin
   }
   
# move icon for ChocolateyGUI
# https://community.chocolatey.org/packages/chocolateygui
$shortcutName = 'Chocolatey GUI.lnk'
if (Test-Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Chocolatey\$shortcutName"){
	Move-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Chocolatey\$shortcutName" "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName"
	}

Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Chocolatey" -Recurse -EA SilentlyContinue
Write-Host "  ** Chocolatey folder in Windows Start Menu removed." -Foreground Magenta