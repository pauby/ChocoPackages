$ErrorActionPreference = 'Stop'

$pluginFilename = 'ReadablePassphrase.plgx'

$packageSearch = 'KeePass Password Safe*'
$installPath = ''

Write-Verbose "Searching for Keepass install location."
if ([array]$key = Get-UninstallRegistryKey -SoftwareName $packageSearch) {
    $installPath = $key.InstallLocation
}

if ([string]::IsNullOrEmpty($installPath)) {
    Write-Verbose "Searching '($(Get-ToolsLocation))' for portable install..."
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

$pluginPath = Join-Path -Path $installPath -ChildPath 'Plugins'
Remove-Item -Path (Join-Path -Path $pluginPath -ChildPath $pluginFilename) -Force -ErrorAction SilentlyContinue