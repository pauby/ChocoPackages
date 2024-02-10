$ErrorActionPreference = 'Continue'
# Choco-Cleaner-RT-readmes.hook v0.1.0 Copyleft 2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

$HookName    = "Choco-Cleaner-RT (readmes)"
$ConfigFile  = "$(Get-ToolsLocation)\BCURRAN3\choco-cleaner-rt.config"
$LogFile     = "$(Get-ToolsLocation)\BCURRAN3\choco-cleaner-rt.log"
$DebugInfo   = $False
$DisplayInfo = $True
$LogInfo     = $False

$readme_types = @( "credits.txt","readme.txt","*.md" )

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
	$GotReadMeFiles=Get-ChildItem -Path $env:packageFolder -Recurse -Include $readme_types -ErrorAction SilentlyContinue
	$ReadMeFiles=$GotReadMeFiles.count
	if ($ReadMeFiles -ge 1){
		$GotReadMeFiles | ForEach-Object {$GotReadMeFilesSize=$GotReadMeFilesSize + $_.length}
		$GotReadMeFilesSize = $(($GotReadMeFilesSize/1kb).ToString('N0'))
		Remove-Item -Path $env:packageFolder -Recurse -Include $readme_types -ErrorAction SilentlyContinue
		$GotReadMeFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
		if ($DisplayInfo){
			Write-Host "  ** $HookName`: Deleted $ReadMeFiles unnecessary Chocolatey package embedded readme files saving $GotReadMeFilesSize KB." -Foreground Green
		}
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." } -Foreground Yellow
}
