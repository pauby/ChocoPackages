$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2

$packageName = 'azurepowershell'
$moduleVersion = [version]'6.1.0'
$url = 'https://github.com/Azure/azure-powershell/releases/download/v6.1.0-May2018/azure-powershell.6.1.0.msi'
$checksum = '28bcb88d79897593cea79be964d419c14be98ddd6984e272d040ee4cc5c2c63e'
$checksumType = 'SHA256'

. (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path) -ChildPath helpers.ps1)

Ensure-RequiredPowerShellVersionPresent -RequiredVersion '5.0'

if (Test-AzurePowerShellInstalled -RequiredVersion $moduleVersion)
{
    return
}

$scriptDirectory = $PSScriptRoot # safe to use because we test for PS 3.0+ earlier
$originalMsiLocalPath = Join-Path -Path $scriptDirectory -ChildPath "azure-powershell.${moduleVersion}.msi"

$downloadArguments = @{
    packageName = $packageName
    fileFullPath = $originalMsiLocalPath
    url = $url
    checksum = $checksum
    checksumType = $checksumType
}

Set-StrictMode -Off # unfortunately, builtin helpers are not guaranteed to be strict mode compliant
Get-ChocolateyWebFile @downloadArguments | Out-Null
Set-StrictMode -Version 2

$instArguments = @{
    packageName = $packageName
    installerType = 'msi'
    file = $originalMsiLocalPath
    silentArgs = '/Quiet /NoRestart /Log "{0}\{1}_{2:yyyyMMddHHmmss}.log"' -f $Env:TEMP, $packageName, (Get-Date)
    validExitCodes = @(
        0, # success
        3010 # success, restart required
    )
}

Set-StrictMode -Off
Install-ChocolateyInstallPackage @instArguments

Write-Warning 'You may need to close and reopen PowerShell before the Azure PowerShell modules become available.'
