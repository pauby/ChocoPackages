$ErrorActionPreference = 'Continue'
# Choco-Cleaner-RT-libbad.hook v0.1.0 Copyleft 2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

$HookName    = "Choco-Cleaner-RT (lib-bad)"
$ConfigFile  = "$(Get-ToolsLocation)\BCURRAN3\choco-cleaner-rt.config"
$LogFile     = "$(Get-ToolsLocation)\BCURRAN3\choco-cleaner-rt.log"
$DebugInfo   = $False
$DisplayInfo = $True
$LogInfo     = $False

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

if (Test-ProcessAdminRights -and (Test-Path $env:ChocolateyInstall\lib-bad)) {
	$GotLibBadFiles=Get-ChildItem -Path $env:ChocolateyInstall\lib-bad -Exclude "$env:chocolateyPackageName" -Recurse -ErrorAction SilentlyContinue
	$LibBadFiles=$GotLibBadFiles.count
	if ($LibBadFiles -ge 1){
		$GotLibBadFiles | ForEach-Object {$GotLibBadFilesSize=$GotLibBadFilesSize + $_.length}
		$GotLibBadFilesSize = $(($GotLibBadFilesSize/1kb).ToString('N0'))
        Get-ChildItem -Path "$env:ChocolateyInstall\lib-bad" -Exclude "$env:chocolateyPackageName" | ForEach-Object {Remove-Item $_ -Recurse -ErrorAction SilentlyContinue}
		$GotLibBadFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
		if ($DisplayInfo){
			Write-Host "  ** $HookName`: Deleted $LibBadFiles unnecessary Chocolatey bad package files from lib-bad saving $GotLibBadFilesSize KB." -Foreground Green
		}
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." } -Foreground Yellow
}
