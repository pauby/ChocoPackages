$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsSSD{
$IsSSD=(Get-WmiObject Win32_DiskDrive).Model
if ($IsSSD -match "SSD") {return $true} else {return $false}
}
