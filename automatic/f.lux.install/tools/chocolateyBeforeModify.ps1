$ErrorActionPreference = 'Stop'

Write-Verbose "Stopping the 'flux' process if it is running."
Get-Process -Name 'flux' -ErrorAction SilentlyContinue | Stop-Process