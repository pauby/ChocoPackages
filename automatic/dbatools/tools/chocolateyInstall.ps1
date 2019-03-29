$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$moduleName = 'dbatools'  # this may be different from the package name and different case

if ($PSVersionTable.PSVersion.Major -lt 3) {
    throw "$moduleName) module requires a minimum of PowerShell v3."
}

# module may already be installed outside of Chocolatey
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

$sourcePath = Join-Path -Path $toolsDir -ChildPath "$modulename.zip"
$destPath   = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName"

if ($PSVersionTable.PSVersion.Major -ge 5)
{
    $destPath     = Join-Path -Path $destPath -ChildPath $env:ChocolateyPackageVersion
}

Write-Verbose "Creating destination directory '$destPath' for module."
New-Item -Path $destPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Extracting '$moduleName' files from '$sourcePath' to '$destPath'."
Get-ChocolateyUnzip -FileFullPath $sourcePath -Destination $destPath

if ($PSVersionTable.PSVersion.Major -lt 4)
{
    $modulePaths = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine') -split ';'
    if ($modulePaths -notcontains $destPath)
    {
        Write-Verbose "Adding '$destPath' to PSModulePath."
        $newModulePath = @($destPath, $modulePaths) -join ';'

        [Environment]::SetEnvironmentVariable('PSModulePath', $newModulePath, 'Machine')
        $env:PSModulePath = $newModulePath
    }
}