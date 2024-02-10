$ErrorActionPreference = 'Continue'
# Choco-Cleaner-RT-desktopicons.hook v0.1.0 Copyleft 2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

$HookName    = "Choco-Cleaner-RT (desktopicons)"
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
    if (Test-Path "$env:USERPROFILE\Desktop") {$UserDesktopIconsPost = Get-ChildItem -Path "$env:USERPROFILE\Desktop\*.lnk"}
    if ($UserDesktopIconsPost -eq $null) {$UserDesktopIconsPost=0}
    if (Test-Path "$env:PUBLIC\Desktop")  {$PublicDesktopIconsPost = Get-ChildItem -Path "$env:PUBLIC\Desktop\*.lnk"}
    if ($PublicDesktopIconsPost -eq $null) {$PublicDesktopIconsPost=0}
   	if ($global:UserDesktopIconsPre.count -ne '0' -and $UserDesktopIconsPost.count -ne '0'){
		$IconsNew = Compare-Object -ReferenceObject ($global:UserDesktopIconsPre) -DifferenceObject ($UserDesktopIconsPost) -PassThru
        if ($IconsNew -ne $null) {
		    Remove-Item $IconsNew.fullname -ErrorAction SilentlyContinue
			$IconsNew.fullname | ForEach-Object {Add2Log "DELETED: $_"}
		    $IconsDeleted=$IconsDeleted + $IconsNew.count
		}
	}
	if ($global:PublicDesktopIconsPre.count -ne '0' -and $PublicDesktopIconsPost.count -ne '0'){
        $IconsNew = Compare-Object -ReferenceObject ($global:PublicDesktopIconsPre) -DifferenceObject ($PublicDesktopIconsPost) -PassThru
        if ($IconsNew -ne $null) {
	 	    Remove-Item $IconsNew.fullname -ErrorAction SilentlyContinue
			$IconsNew.fullname | ForEach-Object {Add2Log "DELETED: $_"}
		    $IconsDeleted=$IconsDeleted + $IconsNew.count
	    }
    }
	if ($DisplayInfo -and $IconsDeleted -ge 1){
	    Write-Host "  ** $HookName`: Deleted $IconsDeleted unwanted desktop icon(s)." -Foreground Green
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." } -Foreground Yellow
}
