$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain
# This is untested and relies heavily on Googlefu

function Get-IsXen{
$IsXen=(Get-WmiObject Win32_ComputerSystem).Manufacturer
if ($IsXen -match "HVM domU") {return $true} else {return $false}
} 
