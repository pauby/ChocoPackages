$ErrorActionPreference = 'Stop'

$toolsDir         = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$moduleName       = 'PSCodeHealth'  # this may be different from the package name and different case

if ($PSVersionTable.PSVersion.Major -lt 5) {
    throw "PSCodeHealth module requires a minimum of PowerShell 5."
}

# module may already be installed outside of Chocolatey
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

$manifestFile = Join-Path -Path $toolsDir -ChildPath "$moduleName\$moduleName.psd1"
$manifest     = Test-ModuleManifest -Path $manifestFile -WarningAction Ignore -ErrorAction Stop
$sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename\*"
$destPath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName\$($manifest.Version.ToString())"

Write-Verbose "Creating destination directory '$destPath' for module."
New-Item -Path $destPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Moving '$moduleName' files from '$sourcePath' to '$destPath'."
Move-Item -Path $sourcePath -Destination $destPath -Force