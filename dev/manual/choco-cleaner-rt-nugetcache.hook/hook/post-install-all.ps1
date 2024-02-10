$ErrorActionPreference = 'Continue'
# Choco-Cleaner-RT-nugetcache.hook v0.1.0 Copyleft 2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

$HookName    = "Choco-Cleaner-RT (nugetcache)"
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

if (Test-ProcessAdminRights -and (Test-Path $env:USERPROFILE\appdata\Local\Nuget\Cache)){
	$GotNugetCacheFiles=Get-ChildItem -Path $env:USERPROFILE\appdata\Local\Nuget\Cache -Recurse -ErrorAction SilentlyContinue
	$NugetCacheFiles=$GotNugetCacheFiles.count
	if ($NugetCacheFiles -ge 1){
		$GotNugetCacheFiles | ForEach-Object {$GotNugetCacheFilesSize=$GotNugetCacheFilesSize + $_.length}
		$GotNugetCacheFilesSize = $(($GotNugetCacheFilesSize/1kb).ToString('N0'))
		Remove-Item -Path $env:USERPROFILE\appdata\Local\Nuget\Cache -Recurse -ErrorAction SilentlyContinue
		$GotNugetCacheFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
	    if ($DisplayInfo){
			Write-Host "  ** $HookName`: Deleted $NugetCacheFiles unnecessary Nuget cache files saving $GotNugetCacheFilesSize KB." -Foreground Green
		}
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." } -Foreground Yellow
}
