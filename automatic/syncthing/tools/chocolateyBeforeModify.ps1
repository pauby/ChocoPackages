$process = Get-Process qbittorrent -ErrorAction SilentlyContinue
if ($runningappl) {
  $runningappl | Stop-Process
  Sleep 5
  if (!$runningappl.HasExited) {
    $runningappl | Stop-Process
  }
}
Remove-Variable $process
