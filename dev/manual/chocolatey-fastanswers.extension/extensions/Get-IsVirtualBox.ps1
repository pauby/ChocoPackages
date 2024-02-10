$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsVirtualBox{
$IsVirtualBox=(Get-WmiObject Win32_ComputerSystem).Model
if ($IsVirtualBox -match "VirtualBox") {return $true} else {return $false}
}
