$ErrorActionPreference = 'Stop'

$versPath = 'vim91'
$destDir = Join-Path -Path $env:ProgramFiles -ChildPath "Vim"

# Apparently doesn't have a non-interactive mode. Send 'y' to its input
Set-Content -Path "$env:TEMP\vimuninstallinput" -Value 'y'
Start-Process -FilePath "$destDir\$versPath\uninstall.exe" -ArgumentList '-nsis' -RedirectStandardInput "$env:TEMP\vimuninstallinput" -Wait
Remove-Item "$env:TEMP\vimuninstallinput"
Remove-Item $destDir -Force -Recurse
