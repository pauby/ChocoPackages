$ErrorActionPreference = 'Stop'
$packageName     = 'choco-cleaner-rt'
$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$ScriptDir       = Test-Path "$(Get-ToolsLocation)\BCURRAN3"
$ScriptConfig    = 'choco-cleaner-rt.config'

# New storage location moving forward for all my Chocolatey scripts
if (!(Test-Path "$ScriptDir")) { New-Item -Path "$(Get-ToolsLocation)" -Name "BCURRAN3" -ItemType "Directory" | Out-Null }

# Move config file and cleanup if not
if (!(Test-Path "$ScriptDir\$ScriptConfig")) { Move-Item "$toolsDir\$ScriptConfig" "$ScriptDir" -Force }
Remove-Item "$toolsDir\$ScriptConfig" -Force -ErrorAction SilentlyContinue | Out-Null

if (!(Test-Path "$env:ChocolateyInstall\lib\choco-cleaner")){
	Write-Host "  ** You might also want to check out the original Choco-Cleaner:" -Foreground Magenta
	Write-Host "  ** https://community.chocolatey.org/packages/choco-cleaner" -Foreground Magenta
}
