$ErrorActionPreference = 'Continue'
# Choco-Cleaner-RT-dotchocolatey.hook v0.1.0 Copyleft 2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

$HookName    = "Choco-Cleaner-RT (dotchocolatey)"
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

if (Test-ProcessAdminRights) {
	
	$InstalledPackages= Get-ChildItem -Path $env:ChocolateyInstall\lib\* -Directory -Name
	$count = 0
	do {
		if (Test-Path "$env:ChocolateyInstall\lib\$($InstalledPackages[$count])\$($InstalledPackages[$count]).nuspec") {
			[xml]$nuspecFile = Get-Content "$env:ChocolateyInstall\lib\$($InstalledPackages[$count])\$($InstalledPackages[$count]).nuspec"
	        $InstalledPackages[$count] = $($InstalledPackages[$count]) + "." + $nuspecFile.package.metadata.version
		}
		$count++
	} while ($count -le $InstalledPackages.count)

    $DotChocolateyDirs =  Get-ChildItem -Path $env:ChocolateyInstall\.chocolatey\* -Directory -Name
	
	# doesn't recognize diff with .0 at end, i.e. googledrive.77.0.3 and googledrive.77.0.3.0 - need to handle above in do while loop
	$delta = $DotChocolateyDirs | Where-Object {$InstalledPackages -NotContains $_}
	$DotChocolateyFiles2Delete=$delta | ForEach-Object $_ {Get-ChildItem -Path $env:ChocolateyInstall\.chocolatey\$_}
    $DeltaCount=$DotChocolateyFiles2Delete.count
	if ($DeltaCount -ge 1){
	    $DotChocolateyFiles2Delete | ForEach-Object {$DeltaSize=$DeltaSize + $_.length}
        Remove-Item $DotChocolateyFiles2Delete.fullname -WhatIf -Verbose -Recurse -Force # Deletes files - need this?
		$DotChocolateyFiles2Delete.fullname | ForEach-Object {Add2Log "DELETED: $_"}
	}
	$delta | ForEach-Object {Remove-Item $env:ChocolateyInstall\.chocolatey\$_ -WhatIf -Verbose -Recurse -Force; Add2Log "DELETED: $_"} # Deletes the dirs
	$DeltaSize = $(($DeltaSize/1kb).ToString('N0'))
    if ($DisplayInfo){
		Write-Host "  ** $HookName`: Deleted $DeltaCount unnecessary Chocolatey package snapshot files saving $DeltaSize KB." -Foreground Green
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." } -Foreground Yellow
}
