$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsIntelCPU{
$IsIntelCPU=(Get-WmiObject -class Win32_Processor)
if ($IsIntelCPU.manufacturer -eq "GenuineIntel") {return $true} else {return $false}
}
