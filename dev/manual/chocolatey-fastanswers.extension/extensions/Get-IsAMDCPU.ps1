$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsAMDCPU{
$IsAMDCPU=(Get-WmiObject -class Win32_Processor)
if ($IsAMDCPU.manufacturer -eq "AuthenticAMD") {return $true} else {return $false}
}
