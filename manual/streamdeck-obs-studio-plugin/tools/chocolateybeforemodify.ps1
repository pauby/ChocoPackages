$ErrorActionPreference = 'Stop'

Get-Process -Name 'obs64' -ErrorAction SilentlyContinue | Stop-Process
