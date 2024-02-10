$ErrorActionPreference = 'Continue'
# Choco-Cleaner-RT-chocolateycache.hook v0.1.1 Copyleft 2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

$HookName    = "Choco-Cleaner-RT (chocolateycache)"
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

# Import chocolatey.config and get cacheLocation if set
[xml]$ChocoConfigFile = Get-Content "$env:ChocolateyInstall\config\chocolatey.config"
$cacheLocation = $ChocoConfigFile.chocolatey.config | ForEach-Object { $_.add } | Where-Object { $_.key -eq 'cacheLocation' } | Select-Object -Expand value

# Configured cache location
if ($cacheLocation){
	if (Test-ProcessAdminRights -and (Test-Path $cacheLocation)){
	    $GotCacheFiles=Get-ChildItem -Path $cacheLocation -Recurse -ErrorAction SilentlyContinue
	    $CacheFiles=$GotCacheFiles.count
	    if ($CacheFiles -ge 1){
    		$GotCacheFilesSize=0
	    	$GotCacheFiles | ForEach-Object {$GotCacheFilesSize=$GotCacheFilesSize + $_.length}
		    $GotCacheFilesSize = $(($GotCacheFilesSize/1kb).ToString('N0'))
		    Remove-Item -Path $cacheLocation -Recurse -ErrorAction SilentlyContinue
		    $GotCacheFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
	        if ($DisplayInfo){ Write-Host "  ** $HookName`: Deleted $CacheFiles unnecessary Chocolatey cache files saving $GotCacheFilesSize KB." -Foreground Green }
	    }
    } else {
		if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." -Foreground Yellow }
	}
}

# C:\Users\username\appdata\Local\temp\chocolatey
if (Test-Path $env:USERPROFILE\appdata\local\temp\chocolatey){
	$GotCacheFiles=Get-ChildItem -Path $env:USERPROFILE\appdata\Local\temp\chocolatey -Recurse -ErrorAction SilentlyContinue
	$CacheFiles=$GotCacheFiles.count
	if ($CacheFiles -ge 1){
		$GotCacheFilesSize=0
		$GotCacheFiles | ForEach-Object {$GotCacheFilesSize=$GotCacheFilesSize + $_.length}
		$GotCacheFilesSize = $(($GotCacheFilesSize/1kb).ToString('N0'))
		Remove-Item -Path $env:USERPROFILE\appdata\local\temp\chocolatey -Recurse -ErrorAction SilentlyContinue
		$GotCacheFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
	    if ($DisplayInfo){ Write-Host "  ** $HookName`: Deleted $CacheFiles unnecessary Chocolatey cache files saving $GotCacheFilesSize KB." -Foreground Green }
	}
}

# C:\Users\username\appdata\Local\temp\ChocolateyScratch
if (Test-Path $env:USERPROFILE\appdata\local\temp\ChocolateyScratch){
	$GotCacheFiles=Get-ChildItem -Path $env:USERPROFILE\appdata\Local\temp\ChocolateyScratch -Recurse -ErrorAction SilentlyContinue
	$CacheFiles=$GotCacheFiles.count
	if ($CacheFiles -ge 1){
		$GotCacheFilesSize=0
		$GotCacheFiles | ForEach-Object {$GotCacheFilesSize=$GotCacheFilesSize + $_.length}
		$GotCacheFilesSize = $(($GotCacheFilesSize/1kb).ToString('N0'))
		Remove-Item -Path $env:USERPROFILE\appdata\local\temp\ChocolateyScratch -Recurse -ErrorAction SilentlyContinue
		$GotCacheFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
	    if ($DisplayInfo){ Write-Host "  ** $HookName`: Deleted $CacheFiles unnecessary Chocolatey cache files saving $GotCacheFilesSize KB." -Foreground Green	}
	}
}

# C:\WINDOWS\temp\chocolatey
if (Test-ProcessAdminRights -and (Test-Path $env:SystemRoot\temp\chocolatey)){
	$GotCacheFiles=Get-ChildItem -Path $env:SystemRoot\temp\chocolatey -Recurse -ErrorAction SilentlyContinue
	$CacheFiles=$GotCacheFiles.count
	if ($CacheFiles -ge 1){
		$GotCacheFilesSize=0
		$GotCacheFiles | ForEach-Object {$GotCacheFilesSize=$GotCacheFilesSize + $_.length}
		$GotCacheFilesSize = $(($GotCacheFilesSize/1kb).ToString('N0'))
		Remove-Item -Path $env:SystemRoot\temp\chocolatey -Recurse -ErrorAction SilentlyContinue
		$GotCacheFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
	    if ($DisplayInfo){ Write-Host "  ** $HookName`: Deleted $CacheFiles unnecessary Chocolatey cache files saving $GotCacheFilesSize KB." -Foreground Green }
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." -Foreground Yellow }
}

# C:\WINDOWS\temp\ChocolateyScratch\
if (Test-ProcessAdminRights -and (Test-Path $env:SystemRoot\temp\ChocolateyScratch)){
	$GotCacheFiles=Get-ChildItem -Path $env:SystemRoot\temp\ChocolateyScratch -Recurse -ErrorAction SilentlyContinue
	$CacheFiles=$GotCacheFiles.count
	if ($CacheFiles -ge 1){
		$GotCacheFilesSize=0
		$GotCacheFiles | ForEach-Object {$GotCacheFilesSize=$GotCacheFilesSize + $_.length}
		$GotCacheFilesSize = $(($GotCacheFilesSize/1kb).ToString('N0'))
		Remove-Item -Path $env:SystemRoot\temp\ChocolateyScratch -Recurse -ErrorAction SilentlyContinue
		$GotCacheFiles.fullname | ForEach-Object {Add2Log "DELETED: $_"}
	    if ($DisplayInfo){ Write-Host "  ** $HookName`: Deleted $CacheFiles unnecessary Chocolatey cache files saving $GotCacheFilesSize KB." -Foreground Green	}
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." -Foreground Yellow }
}
