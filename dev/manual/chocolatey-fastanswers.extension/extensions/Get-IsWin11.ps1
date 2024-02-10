$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2.1 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWin11{
 $workstation=Get-IsWinWorkstation
 if ($workstation -eq $false) {return $false}
 $OSMajor=[Environment]::OSVersion.Version.Major
 $OSBuild=[Environment]::OSVersion.Version.Build
 if ($OSMajor -eq 10 -and $OSBuild -ge 22000) {return $true} else {return $false}
}  
