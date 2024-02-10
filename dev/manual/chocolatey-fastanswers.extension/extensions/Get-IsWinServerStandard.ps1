$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinServerStandard{
$server=Get-IsWinServer
if ($server -ne $true) {
   return $false
   } else {
     $IsServerStandard=((Get-WmiObject win32_operatingsystem).caption)
     if ($IsServerStandard -match "Standard") {return $true} else {return $false}
    }
}	
