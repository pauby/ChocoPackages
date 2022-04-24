$ErrorActionPreference = 'Stop'

Get-Process -Name 'WaveLink' -ErrorAction SilentlyContinue | Stop-Process