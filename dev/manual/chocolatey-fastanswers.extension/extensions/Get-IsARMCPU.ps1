$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsARMCPU{
$IsARMCPU=(Get-WmiObject -class Win32_Processor)
if ($IsARMCPU.architecture -eq "5") {return $true} else {return $false}
}
