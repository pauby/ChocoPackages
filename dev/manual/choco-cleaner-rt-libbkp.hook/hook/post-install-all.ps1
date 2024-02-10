$ErrorActionPreference = 'Continue'
# Choco-Cleaner-RT-libbkp.hook v0.1.1 Copyleft 2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

$HookName    = "Choco-Cleaner-RT (lib-bkp)"
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

function Add2Log {
    Param ( [string]$comment )
	
	if ($LogInfo) {
		Write-Output "$(Get-Date) [INFO ] $comment" >> "$LogFile"
	}
}

if (Test-ProcessAdminRights -and (Test-Path $env:ChocolateyInstall\lib-bkp)) {
	$GotLibBkpFiles=(Get-ChildItem -Path $env:ChocolateyInstall\lib-bkp -Exclude "$env:chocolateyPackageName" -ErrorAction SilentlyContinue | Get-ChildItem -Recurse)
	$LibBkpFiles=$GotLibBkpFiles.count
	if ($LibBkpFiles -ge 1){
		$GotLibBkpFiles | ForEach-Object {$GotLibBkpFilesSize=$GotLibBkpFilesSize + $_.length}
		$GotLibBkpFilesSize = $(($GotLibBkpFilesSize/1kb).ToString('N0'))
        $GotLibBkpFiles | ForEach-Object { Remove-Item $_.fullname -Recurse -ErrorAction SilentlyContinue; Add2Log "DELETED: $($_.fullname)"}
		Get-ChildItem -Path "$env:ChocolateyInstall\lib-bkp" -Exclude "$env:chocolateyPackageName" | ForEach-Object { Remove-Item $_ -Recurse -ErrorAction SilentlyContinue; Add2Log "DELETED: $($_)"}
		if ($DisplayInfo){
			Write-Host "  ** $HookName`: Deleted $LibBkpFiles unnecessary Chocolatey backup package files from lib-bkp saving $GotLibBkpFilesSize KB." -Foreground Green
		}
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." } -Foreground Yellow
}
