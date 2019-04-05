$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$moduleName = 'dbachecks'  # this may be different from the package name and different case

if ($PSVersionTable.PSVersion.Major -lt 5) {
    throw "$moduleName module requires a minimum of PowerShell v5."
}

# module may already be installed outside of Chocolatey
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

$sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename.zip"
$destPath   = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName\$env:ChocolateyPackageVersion"

Write-Verbose "Creating destination directory '$destPath' for module."
New-Item -Path $destPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Extracting '$moduleName' files from '$sourcePath' to '$destPath'."
Get-ChocolateyUnzip -FileFullPath $sourcePath -Destination $destPath