$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$moduleName = $env:ChocolateyPackageName  # this may be different from the package name and different case
$moduleVersion = $env:ChocolateyPackageVersion

# module may already be installed outside of Chocolatey
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

$manifestFile = Join-Path -Path $toolsDir -ChildPath "$moduleName\$moduleName.psd1"

$sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename\*"
$destPath   = Join-Path -Path $env:ProgramFiles -ChildPath "PowerShell\Modules\$moduleName\$moduleVersion"

# if a forced install we need to remove the current files because it will fail otherwise
if (Test-Path ($destPath)) {
    Write-Verbose "Removing existing files in '$destPath'."
    Remove-Item $destPath -Recurse -Force
}

Write-Verbose "Creating destination directory '$destPath' for module."
New-Item -Path $destPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Moving '$moduleName' files from '$sourcePath' to '$destPath'."
Move-Item -Path $sourcePath -Destination $destPath -Force

Write-Host "AWSLambdaPSCore module requires, and must be run from, PowerShell Core." -ForegroundColor Cyan