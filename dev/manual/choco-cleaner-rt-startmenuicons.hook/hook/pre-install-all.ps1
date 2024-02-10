$ErrorActionPreference = 'Continue'
# Choco-Cleaner-RT-startmenuicons.hook v0.1.0 Copyleft 2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

$HookName    = "Choco-Cleaner-RT (startmenuicons)"
$ConfigFile  = "$(Get-ToolsLocation)\BCURRAN3\choco-cleaner-rt.config"
$LogFile     = "$(Get-ToolsLocation)\BCURRAN3\choco-cleaner-rt.log"
$DebugInfo   = $False
$DisplayInfo = $True
$LogInfo     = $False

$IconsDeleted=0

if (Test-Path "$ConfigFile"){
    [xml]$Config = Get-Content "$ConfigFile"
	if ($Config.Settings.Preferences.DebugInfo -eq "true") {$DebugInfo=$True} else {$DebugInfo=$False}
    if ($Config.Settings.Preferences.DisplayInfo -eq "true") {$DisplayInfo=$True} else {$DisplayInfo=$False}
    if ($Config.Settings.Preferences.LogInfo -eq "true") {$LogInfo=$True} else {$LogInfo=$False}
}

if ($DebugInfo) { Write-Host "  ** Running $HookName..." -Foreground Yellow }

if (!(Test-Path "$(Get-ToolsLocation)\BCURRAN3")) {$LogInfo=$False}

function Add2Log {
    Param ( [string]$comment )
	
	if ($LogInfo) {
		Write-Output "$(Get-Date) [INFO ] $comment" >> "$LogFile"
	}
}

if (Test-ProcessAdminRights) {
    if (Test-Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs") {$global:UserStartMenuIconsPre = Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\*.lnk" -Recurse}
    if ($global:UserStartMenuIconsPre -eq $null) {$global:UserStartMenuIconsPre=0}
    if (Test-Path "$env:ProgramData\Microsoft\Windows\Start Menu") {$global:PublicStartMenuIconsPre = Get-ChildItem -Path "$env:ProgramData\Microsoft\Windows\Start Menu\*.lnk" -Recurse}
    if ($global:PublicStartMenuIconsPre -eq $null) {$global:PublicStartMenuIconsPre=0}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." } -Foreground Yellow
}
