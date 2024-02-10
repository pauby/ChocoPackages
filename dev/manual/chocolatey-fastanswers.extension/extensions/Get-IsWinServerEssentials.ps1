$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinServerEssentials{
$server=Get-IsWinServer
if ($server -ne $true) {
   return $false
   } else {
     $IsServerEssentials=((Get-WmiObject win32_operatingsystem).caption)
     if ($IsServerEssentials -match "Essentials") {return $true} else {return $false}
    }
}	
