$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsVMware{
$IsVMware=(Get-WmiObject Win32_ComputerSystem).Manufacturer
if ($IsVMware -like "*VMware*") {return $true} else {return $false}
} 
