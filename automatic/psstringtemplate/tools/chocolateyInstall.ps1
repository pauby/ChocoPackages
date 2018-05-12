$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$moduleName = 'PSStringTemplate'  # this may be different from the package name and different case

if ($PSVersionTable.PSVersion.Major -lt 3) {
    throw "$moduleName module requires a minimum of PowerShell v3."
}

# module may already be installed outside of Chocolatey
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

$sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename\*"
$destPath   = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName"

if ($PSVersionTable.PSVersion.Major -ge 5) {
    $manifestFile = Join-Path -Path $toolsDir -ChildPath "$moduleName\$moduleName.psd1"
    $manifest = Test-ModuleManifest -Path $manifestFile -WarningAction Ignore -ErrorAction Stop
    $destPath = Join-Path -Path $destPath -ChildPath $manifest.Version.ToString()
}

Write-Verbose "Module version '$($matches.version)' found."
$destPath = Join-Path -Path $destPath -ChildPath $matches.version

Write-Verbose "Creating destination directory '$destPath' for module."
New-Item -Path $destPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Moving '$moduleName' files from '$sourcePath' to '$destPath'."
Move-Item -Path $sourcePath -Destination $destPath -Force