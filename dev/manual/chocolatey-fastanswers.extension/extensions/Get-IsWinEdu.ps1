$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinEdu{
$IsWinEdu=(Get-WmiObject win32_operatingsystem).caption
 if ($IsWinEdu -match "Education") {return $true} else {return $false}
}
