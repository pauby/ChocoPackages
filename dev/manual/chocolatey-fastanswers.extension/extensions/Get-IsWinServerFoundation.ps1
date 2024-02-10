$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinServerFoundation{
$server=Get-IsWinServer
if ($server -ne $true) {
     return $false
   } else {
     $IsServerFoundation=((Get-WmiObject win32_operatingsystem).caption)
     if ($IsServerFoundation -match "Foundation") {return $true} else {return $false}
    }
}	
