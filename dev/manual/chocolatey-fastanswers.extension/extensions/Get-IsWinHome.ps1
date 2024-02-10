$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinHome{
$IsWinHome=(Get-WmiObject win32_operatingsystem).caption
 if ($IsWinHome -match "Home") {return $true} else {return $false}
}
