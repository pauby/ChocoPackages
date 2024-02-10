$ErrorActionPreference = 'Stop'
# chocolatey-fastanswers.extension v0.0.2 by Bill Curran AKA BCURRAN3 - public domain

function Get-IsWinServer2019{
$server=Get-IsWinServer
if ($server -eq $false) {return $false}
# Build 10.0.17623 is the 2018/03/30 initial beta of Server 2019
# Build 10.0.17763 is the 2018/10/02 initial release of Server 2019
$major=[Environment]::OSVersion.Version.Major
$minor=[Environment]::OSVersion.Version.Minor
$build=[Environment]::OSVersion.Version.Build
if ($major -eq "10" -and $minor -eq "0" -and $build -ge "17763") {return $true} else {return $false}

}
