$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-Is64{
$Is64=(Get-WmiObject Win32_processor).addresswidth
 if ($Is64 -eq 64) {return $true} else {return $false}
}
