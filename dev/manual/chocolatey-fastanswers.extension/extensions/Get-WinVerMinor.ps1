$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-WinVerMinor{
$WinVerMinor=[Environment]::OSVersion.Version.Minor
return $WinVerMinor
}
