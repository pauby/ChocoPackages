Get-ChildItem $PSScriptRoot\*.ps1 -Exclude all.ps1 | ForEach { . $_ }
