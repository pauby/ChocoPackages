$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWin8{
$workstation=Get-IsWinWorkstation
if ($workstation -eq $false) {return $false}
$IsWin8=[Environment]::OSVersion.Version.Major
if ($IsWin8 -eq "6" -and $IsWin8 -lt "7") {return $true} else {return $false}
}
