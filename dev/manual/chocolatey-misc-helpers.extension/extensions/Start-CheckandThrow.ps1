$ErrorActionPreference = 'Stop'
# chocolatey-misc-helpers.extension v0.0.4 (08-24-2020) by Bill Curran - public domain
# Checks for and throws install if $ProcessName is running
# Good for aborting installation of portable programs if they are running. Otherwise Chocolatey might think the package installed but you're still running the old version. This is an alternative to just stopping the process.

function Start-CheckandThrow($ProcessName){

if ((Get-Process "$ProcessName" -ea SilentlyContinue) -eq $Null){
    return
  } else { 
    Write-Warning "  ** Aborting install as $ProcessName is already running..."
	Write-Warning "  ** Please quit the program and try the upgrade again."
	throw
  }
}
