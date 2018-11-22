$ErrorActionPreference = 'Stop'

$moduleName = $env:ChocolateyPackageName
$sourcePath = Join-Path -Path $env:ProgramFiles -ChildPath "PowerShell\Modules\$moduleName"

Write-Verbose "Removing all version of '$moduleName' from '$sourcePath'."
Remove-Item -Path $sourcePath -Recurse -Force -ErrorAction SilentlyContinue