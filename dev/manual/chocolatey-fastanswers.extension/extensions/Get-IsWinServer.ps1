$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinServer{
$IsServer=(Get-WmiObject win32_operatingsystem).caption
 if ($IsServer -match "Server") {return $true} else {return $false}
}
