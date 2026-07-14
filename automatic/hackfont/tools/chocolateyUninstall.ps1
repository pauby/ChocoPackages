$ErrorActionPreference = 'Stop'

$Removed = Remove-Font 
   
if ($Removed -eq 0) {
   Throw 'All font removal attempts failed!'
} else {
   Write-Host "$Removed fonts were uninstalled."
}
