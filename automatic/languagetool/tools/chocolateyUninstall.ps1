
$ErrorActionPreference = 'Stop'

$installToolsPath = Get-ToolsLocation
$installPath = Join-Path -Path $installToolsPath -ChildPath 'languagetool'

if (Test-Path -Path $installPath) {
    try {
        Remove-Item -Path $installPath -Force -Recurse
    }
    catch {
        Write-Warning "There was a problem removing the LanguageTool install path '$installPath'. You may have to remove it manually."
    }
}
else {
    Write-Warning "Install path '$installPath' does not exist. LanguageTool could have been uninstalled by other means"
}