$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinWorkstation{
$IsWinWorkstation=(Get-WmiObject win32_operatingsystem).caption
 if ($IsWorkstation -match "Server") {return $false} else {return $true}
}
