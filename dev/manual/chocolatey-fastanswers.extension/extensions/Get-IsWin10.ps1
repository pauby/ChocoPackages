$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWin10{
$workstation=Get-IsWinWorkstation
if ($workstation -eq $false) {return $false}
$IsWin10=[Environment]::OSVersion.Version.Major
if ($IsWin10 -ge "10" -and $IsWin10 -lt "11") {return $true} else {return $false}
}  
