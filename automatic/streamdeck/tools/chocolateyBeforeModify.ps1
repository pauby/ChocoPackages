$ErrorActionPreference = 'Stop'

Get-Process -Name 'StreamDeck' -ErrorAction SilentlyContinue | Stop-Process