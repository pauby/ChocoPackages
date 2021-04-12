$processName = 'syncthing*'
$process = Get-Process -Name $processName

if ($process) {
  Write-Host "Stopping Syncthing process..."
  Stop-Process -InputObject $process
  Start-Sleep -Seconds 3
  
  $process = Get-Process -Name $processName
  
  if ($process) {
    Write-Warning "Syncthing failed to close. `nKilling Syncthing process..."
    Stop-Process -InputObject $process -Force
  }
  Write-Warning "Syncthing will not be started after upgrading..."
}
