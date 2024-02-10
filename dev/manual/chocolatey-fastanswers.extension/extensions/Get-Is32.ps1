$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-Is32{
$Is32=(Get-WmiObject Win32_processor).addresswidth
 if ($Is32 -eq "32") {return $true} else {return $false}
}
