$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$moduleName = 'EditorServicesCommandSuite'  # this may be different from the package name and different case

if ($PSVersionTable.PSVersion -lt [Version]"5.1") {
    throw "$moduleName module requires a minimum of PowerShell v5.1."
}

# module may already be installed outside of Chocolatey
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

$sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename\*"
$destPath   = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName"

$manifestFile = Join-Path -Path $toolsDir -ChildPath "$moduleName\$moduleName.psd1"
Write-Verbose "Searching manifest file '$manifestFile' for module version."
$verFound = Get-Content -Path $manifestFile -Raw | ForEach-Object { $_ -match '\s*ModuleVersion\s*=\s*[''|""]{1}(?<version>[\d|\.]+)[''|""]{1}' }
if (-not $verFound) {
    throw "Cannot find 'ModuleVersion' in manifest file '$manifestFile'."
}

Write-Verbose "Module version '$($matches.version)' found."
$destPath = Join-Path -Path $destPath -ChildPath $matches.version

Write-Verbose "Creating destination directory '$destPath' for module."
New-Item -Path $destPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Moving '$moduleName' files from '$sourcePath' to '$destPath'."
Move-Item -Path $sourcePath -Destination $destPath -Force