$ErrorActionPreference = 'Stop'

# there is no documented exit codes for the utility, but we do not know of some invalid ones.
$invalidExitCode = @(2)
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

# Check OS version - only works on Windows 10
Write-Debug "OS Name: $($env:OS_NAME)"
if ($env:OS_NAME -ne "Windows 10") {
    throw "Cannot be installed on this version of Windows. Requires Windows 10 x64."
}

Set-Location -Path (Join-Path -Path $toolsDir -ChildPath 'drivers\amd64')
pnputil /add-driver AmtPtpDevice.inf /install
if ($invalidExitCode -contains $LASTEXITCODE) {
    throw "Driver did not install correctly. Please see the previous output from 'pnputil' (exit code $LASTEXITCODE)."
}