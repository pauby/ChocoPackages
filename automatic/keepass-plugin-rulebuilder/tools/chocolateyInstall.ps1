$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$installLog = Join-Path -Path $toolsDir -ChildPath ("{0}-install.log" -f $env:ChocolateyPackageName)

$packageSearch = 'KeePass Password Safe*'
$installPath = ''

Write-Verbose "Searching for Keepass install location."
if ([array]$key = Get-UninstallRegistryKey -SoftwareName $packageSearch) {
    $installPath = $key.InstallLocation
}

if ([string]::IsNullOrEmpty($installPath)) {
    Write-Verbose "Searching '$(Get-ToolsLocation)' for portable install..."
    $portPath = Join-Path -Path (Get-ToolsLocation) -ChildPath "keepass"
    $installPath = Get-ChildItem -Directory "$portPath*" -ErrorAction SilentlyContinue
}

if ([string]::IsNullOrEmpty($installPath)) {
    Write-Verbose "Searching '$env:Path' for unregistered install..."
    $installFullName = Get-Command -Name keepass -ErrorAction SilentlyContinue
    if ($installFullName) {
        $installPath = Split-Path $installFullName.Path -Parent
    }
}

if ([string]::IsNullOrEmpty($installPath)) {
    throw "$($packageSearch) not found."
}
else {
    Write-Verbose "Found Keepass install location at '$installPath'."
}

$sourcePath = Join-Path -Path $toolsDir -ChildPath 'RuleBuilder.dll'
$destPath  = Join-Path -Path $installPath -ChildPath 'Plugins'

$null = Copy-Item -Path $sourcePath -Destination $destPath -Force

# save the install path so we can use it at uninstall
Set-Content -Path $installLog -Value (Join-Path -Path $destPath -ChildPath 'RuleBuilder.dll') -Force

if (Get-Process -Name 'KeePass' -ErrorAction SilentlyContinue) {
    Write-Warning ("Keepass is currently running. '{0}' will be available at next restart." -f $env:ChocolateyPackageName)
}
else {
    Write-Host ("'{0}' will be loaded the next time KeePass is started." -f $env:ChocolateyPackageName)
}