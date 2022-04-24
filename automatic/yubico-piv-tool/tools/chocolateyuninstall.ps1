$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$configPath = Join-Path -Path $toolsDir -ChildPath 'package-config.json'

if (Test-Path -Path $configPath) {
    $packageConfig = Get-Content -Path $configPath | ConvertFrom-Json

    if ($packageConfig.UpdatedPath -eq $true) {
        Write-Host "Removing '$($packageConfig.InstallPath)' from your System path."

        $currentSystemPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine')
        $newSystemPath = ($currentSystemPath -split ';' | Where-Object { $_ -ne $packageConfig.InstallPath }) -join ';'
        [Environment]::SetEnvironmentVariable('PATH', $newSystemPath, 'Machine')
    }
}