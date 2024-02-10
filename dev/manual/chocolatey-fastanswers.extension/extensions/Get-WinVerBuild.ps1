$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-WinVerBuild{
$WinVerBuild=[Environment]::OSVersion.Version.Build
return $WinVerBuild
}
