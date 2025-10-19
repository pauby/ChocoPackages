#$ErrorActionPreference = 'Stop'
$packageName  = 'homeassistant'
$shortcutName = 'Home Assistant.lnk'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$PythonPackages=&pip3 list

if ($PythonPackages -match "homeassistant"){
# Home Assistant normal upgrade
    pip3 install --upgrade homeassistant==$env:ChocolateyPackageVersion
	Write-Warning "Home Assistant has been upgraded. You must restart stop and restart HASS for changes to take effect." -Foreground Magenta
  } else {
# Home Assistant normal install
    pip3 install homeassistant==$env:ChocolateyPackageVersion
}

Install-ChocolateyShortcut -shortcutFilePath "$env:Public\Desktop\$shortcutName" -targetPath 'py' -Arguments '-m homeassistant --open-ui' -IconLocation "$toolsDir\homeassistant.ico" -RunAsAdmin
Install-ChocolateyShortcut -shortcutFilePath "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -targetPath 'py' -Arguments '-m homeassistant --open-ui' -IconLocation "$toolsDir\homeassistant.ico" -RunAsAdmin

Write-Host " ** ^^^ You can ignore the icon creation warnings if Python is in your path." -Foreground Magenta

# REFERENCE
# Home Assistant run command
# py -m homeassistant --open-ui

# Home Assistant upgrade command (must shutdown first)
# pip3 install --upgrade homeassistant

# Home Assistant Python virtual environment install
#py -m venv homeassistant
#cd homeassistant
#Scripts\activate.bat
#py -m pip install wheel setuptools pip
#py -m pip install homeassistant

# Home Assistant Python virtual environment run command
#hass

# Home Assistant Python virtual environment upgrade command  (must shutdown first)
#cd homeassistant
#Scripts\activate.bat
#py -m pip install --upgrade homeassistant
