$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2.1 by Bill Curran AKA BCURRAN3 - public domain
# NOTE: This is untested. I have not installed WS2022 yet :->

function Get-IsWinServer2022{
$server=Get-IsWinServer
if ($server -eq $false) {return $false}
# Build 20348.169 is the 08/18/2021 release
$major=[Environment]::OSVersion.Version.Major
$minor=[Environment]::OSVersion.Version.Minor
$build=[Environment]::OSVersion.Version.Build
if ($major -eq "10" -and $minor -eq "0" -and $build -ge "20348") {return $true} else {return $false}

}
