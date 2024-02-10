$ErrorActionPreference = 'Continue'
# Choco-Cleaner-RT-nupkgs.hook v0.1.0 Copyleft 2023 by Bill Curran AKA BCURRAN3
# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Suggestions? Problems? Open a GitHub issue at https://github.com/bcurran3/ChocolateyPackages/issues

$HookName    = "Choco-Cleaner-RT (nupkgs)"
$ConfigFile  = "$(Get-ToolsLocation)\BCURRAN3\choco-cleaner-rt.config"
$LogFile     = "$(Get-ToolsLocation)\BCURRAN3\choco-cleaner-rt.log"
$DebugInfo   = $False
$DisplayInfo = $True
$LogInfo     = $False

# All 7Zip supported formats plus EXE, MSU, MSP, APPX, APPXBUNDLE, IMG - Is anything else needed?
$BinaryExtensions=@(
	"*.exe","*.img","*.msu","*.msp","*.appx","*.appxbundle","*.7z","*.xz",
	"*.bzip2","*.gzip","*.tar","*.zip","*.wim","*.ar","*.arj","*.cab","*.chm",
	"*.cpio","*.cramfs","*.dmg","*.ext","*.fat","*.gpt","*.hfs","*.ihex",
	"*.iso","*.lzh","*.lzma","*.mbr","*.msi","*.nsis","*.ntfs","*.qcow2",
	"*.rar","*.rpm","*.squashfs","*.udf","*.uefi","*.vdi","*.vhd","*.vmdk",
	"*.xar","*.z","*.dll"
)

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
   $nupkgsSizeBefore = (Get-ChildItem $env:packageFolder\$env:chocolateyPackageName.nupkg).length
   & $env:ChocolateyInstall\tools\7z.exe d -r -tZIP $env:packageFolder\$env:chocolateyPackageName.nupkg $BinaryExtensions | Out-Null
   $nupkgsSizeAfter = (Get-ChildItem $env:packageFolder\$env:chocolateyPackageName.nupkg).length
   $nupkgsSpaceFreed = ($nupkgsSizeBefore - $nupkgsSizeAfter)
   $nupkgsSpaceFreed = $(($nupkgsSpaceFreed/1kb).ToString('N0'))
   if ($nupkgsSpaceFreed -gt 0){
	   Add2Log "SHRUNK: $env:chocolateyPackageName.nupkg"
   }
    if ($DisplayInfo -and $nupkgsSpaceFreed -gt 0) {
		Write-Host "  ** $HookName`: Deleted unnecessary Chocolatey embedded archive files saving $nupkgsSpaceFreed KB." -Foreground Green
	}
} else {
	if ($DisplayInfo){ Write-Host "  ** $HookName requires admin rights." } -Foreground Yellow
}
