$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsInDomain{
if ($env:LOGONSERVER -ne "\\$env:COMPUTERNAME") {return $true} else {return $false}
}
