$ErrorActionPreference = 'Stop'
$packageName  = 'homeassistant'
$shortcutName = 'Home Assistant.lnk'

pip3 uninstall homeassistant -y

Remove-Item "$ENV:Public\Desktop\$shortcutName" -Force -ErrorAction SilentlyContinue
Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -Force -ErrorAction SilentlyContinue
