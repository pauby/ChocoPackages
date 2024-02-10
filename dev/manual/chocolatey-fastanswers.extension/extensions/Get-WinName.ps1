$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-WinName{
$WinName=(Get-WmiObject win32_operatingsystem).caption
return $WinName
}
