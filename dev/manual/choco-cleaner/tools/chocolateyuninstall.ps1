$ErrorActionPreference = 'Stop'
$packageName     = 'choco-cleaner'
$scriptDir       = "$(Get-ToolsLocation)\BCURRAN3"
$shortcutName    = 'Choco Cleaner.lnk'
$altshortcutName = 'Chocolatey Cleaner.lnk'

$ErrorActionPreference = 'SilentlyContinue'
$GotTask         = (&schtasks /query /tn choco-cleaner) 2> $null
$ErrorActionPreference = 'Stop'
if ($GotTask) {SchTasks /Delete /TN “choco-cleaner” /F}

Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -Force -ErrorAction SilentlyContinue
Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$altshortcutName" -Force -ErrorAction SilentlyContinue
Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\Chocolatey\$shortcutName" -Force -ErrorAction SilentlyContinue
Remove-Item "$ENV:ChocolateyInstall\bin\choco-cleaner.bat" -Force -ErrorAction SilentlyContinue
Remove-Item "$scriptDir\choco-cleaner.*" -Force -ErrorAction SilentlyContinue | Out-Null
$CTL=Get-ToolsLocation
if (!(Get-ChildItem -Path "$CTL\BCURRAN3" | Measure-Object | %{$_.Count})) {
    $ENV:Path.Replace("$CTL\BCURRAN3","") | Out-Null
    Remove-Item "$CTL\BCURRAN3" | Out-Null
   }
