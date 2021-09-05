$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

# Package parameters relate to installer parameters specified at
# https://github.com/Izheil/Quantum-Nox-Firefox-Dark-Full-Theme/wiki/Installer-console-commands
if (Test-Path env:ChocolateyPackageParameters) {
    $params = @{
        statements = $env:ChocolateyPackageParameters
        exeToRun    = Join-Path -Path $toolsDir -ChildPath 'quantum-nox.exe'
        elevated    = $true
    }

    Write-Host "Running with parameters $($params['statements'])"
    Start-ChocolateyProcessAsAdmin @params
}