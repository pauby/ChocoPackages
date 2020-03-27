$ErrorActionPreference = 'Stop'

$invalidExitCode = @(2)

$installedDriver = Get-CimInstance win32_PnPSignedDriver `
    -Filter "Manufacturer = 'Bingxing Wang' and DeviceName like 'Apple USB Precision Touchpad Device%'"
if (-not $installedDriver) {
    throw "Could not uninstall the driver we installed as it could not be found! Perhaps it has been removed outside of the package."
}

# if multiple driver versions were installed there may be more than one
$installedDriver | ForEach-Object {
    pnputil /delete-driver $($_.InfName) /uninstall /force
    if ($invalidExitCode -contains $LASTEXITCODE) {
        throw "There was a problem uninstalling the driver. Please see the previous output from 'pnputil' for more information (exit code $LASTEXITCODE)."
    }
}

Write-Host "The driver has been uninstalled. However you may need to reboot for it to be removed properly."
