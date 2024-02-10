$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsIntelVideo{
$VideoCard=(Get-WmiObject win32_VideoController).description
if ($VideoCard -match "Intel") {return $true} else {return $false}
}  
