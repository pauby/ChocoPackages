$ErrorActionPreference = 'Stop'

Write-Verbose "Stopping the 'gitter' process(es) if it is running."
Get-Process -Name 'gitter' -ErrorAction SilentlyContinue | Stop-Process

Start-Sleep -Milliseconds 500