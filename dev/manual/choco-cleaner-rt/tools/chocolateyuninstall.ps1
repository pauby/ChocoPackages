$ErrorActionPreference = 'Stop'
$packageName     = 'choco-cleaner-rt'
$scriptDir       = "$(Get-ToolsLocation)\BCURRAN3"
$ScriptConfig    = 'choco-cleaner-rt.config'

$ChocoCleanerRTHooksInstalled = Get-ChildItem -Path "$env:ChocolateyInstall\lib\choco-cleaner-rt*.hook"
if ($ChocoCleanerRTHooksInstalled.count -eq 0){
	Remove-Item "$scriptDir\$ScriptConfig" -Force -ErrorAction SilentlyContinue | Out-Null
}
