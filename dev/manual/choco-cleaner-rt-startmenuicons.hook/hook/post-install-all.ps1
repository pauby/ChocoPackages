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
    if (Test-Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs") {$UserStartMenuIconsPost = Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\*.lnk" -Recurse}
    if ($UserStartMenuIconsPost -eq $null) {$UserStartMenuIconsPost=0}
    if (Test-Path "$env:ProgramData\Microsoft\Windows\Start Menu") {$PublicStartMenuIconsPost = Get-ChildItem -Path "$env:ProgramData\Microsoft\Windows\Start Menu\*.lnk" -Recurse}
    if ($PublicStartMenuIconsPost -eq $null) {$PublicStartMenuIconsPost=0}
	if ($global:UserStartMenuIconsPre.count -ne '0' -and $UserStartMenuIconsPost.count -ne '0'){
        $IconsNew = Compare-Object -ReferenceObject ($global:UserStartMenuIconsPre) -DifferenceObject ($UserStartMenuIconsPost) -PassThru
        if ($IconsNew -ne $null) {
	 	    Remove-Item $IconsNew.fullname -WhatIf -Verbose -ErrorAction SilentlyContinue
			$IconsNew.fullname | ForEach-Object {Add2Log "DELETED: $_"}
	 	    $IconsDeleted=$IconsDeleted + $IconsNew.count
	    }
    }
	if ($global:PublicStartMenuIconsPre.count -ne '0' -and $PublicStartMenuIconsPost.count -ne '0'){
        $IconsNew = Compare-Object -ReferenceObject ($global:PublicStartMenuIconsPre) -DifferenceObject ($PublicStartMenuIconsPost) -PassThru
        if ($IconsNew -ne $null) {
	 	    Remove-Item $IconsNew.fullname -WhatIf -Verbose -ErrorAction SilentlyContinue
			$IconsNew.fullname | ForEach-Object {Add2Log "DELETED: $_"}
		    $IconsDeleted=$IconsDeleted + $IconsNew.count
	    }
    }
	if ($DisplayInfo -and $IconsDeleted -ge 1){
	    Write-Host "  ** $HookName`: Deleted $IconsDeleted unwanted Start Menu icon(s)." -Foreground Green
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." } -Foreground Yellow
}
