$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinPro{
$IsWinPro=(Get-WmiObject win32_operatingsystem).caption
 if ($IsWinPro -match "Pro") {return $true} else {return $false}
}
