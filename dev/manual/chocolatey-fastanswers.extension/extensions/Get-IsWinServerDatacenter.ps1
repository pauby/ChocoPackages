$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinServerDatacenter{
$server=Get-IsWinServer
if ($server -ne $true) {
   return $false
   } else {
     $IsServerDatacenter=((Get-WmiObject win32_operatingsystem).caption)
     if ($IsServerDatacenter -match "Datacenter") {return $true} else {return $false}
    }
}	
