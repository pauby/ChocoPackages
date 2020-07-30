$ErrorActionPreference = 'Stop'

$process = Get-Process -Name 'TranslucentTB' -ErrorAction SilentlyContinue

if ($process) {
    $process | Stop-Process -Force
}