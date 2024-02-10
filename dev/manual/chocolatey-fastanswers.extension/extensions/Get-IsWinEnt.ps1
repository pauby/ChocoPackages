$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinEnt{
$IsWinEnt=(Get-WmiObject win32_operatingsystem).caption
 if ($IsWinEnt -match "Enterprise") {return $true} else {return $false}
}
