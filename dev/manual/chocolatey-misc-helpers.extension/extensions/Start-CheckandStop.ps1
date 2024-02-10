$ErrorActionPreference = 'Stop'
# chocolatey-misc-helpers.extension v0.0.4 (08-24-2020) by Bill Curran - public domain
# Start-WaitandStop.ps1 - Checks for and stops $ProcessName if running.
# $ProcessWasRunning can be checked later in scripts to re-run $ProcessName if it was running before stopped.
# $ProcessFullPath is the full path and executable of the stopped process.
# i.e. to re-run the process after an upgrade use: if ($ProcessWasRunning -eq "True") {&"$ProcessFullPath"}

function Start-CheckandStop($ProcessName){
$GLOBAL:ProcessWasRunning=$False

if((Get-Process "$ProcessName" -ea SilentlyContinue) -eq $Null){ 
    Write-Host "  ** $ProcessName currently NOT running." -ForeGround Green
  }else{ 
    Write-Warning "  ** Stopping $ProcessName process..."
	$GLOBAL:ProcessWasRunning = $True
	$GLOBAL:ProcessFullPath = (Get-Process "$ProcessName").path
    Stop-Process -ProcessName "$ProcessName" -Force	
  }
}
