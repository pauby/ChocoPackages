$ErrorActionPreference = 'Stop'

if (Get-Process -Name 'syncthing' -ErrorAction SilentlyContinue) {
    # syncthing is running - stop it gracefully
    Write-Warning "Syncthing process is running. Shutting it down gracefully."
    syncthing cli operations shutdown

    # can take a few seconds to shutdown
    Start-Sleep -Seconds 2
}