$packageName    = 'dependency-server2019'

$IsWinServer=((Get-CimInstance Win32_OperatingSystem | Select-Object Caption) -match "Server")
if ($IsWinServer) {
  } else {
    Write-Warning "This package requires Windows Server 2019."
	throw
  }

# Build 10.0.17763 is the 2018/10/02 initial release of Server 2019
$IsCorrectBuild=[Environment]::OSVersion.Version.Build
if ($IsCorrectBuild -lt "17763")
   {
    Write-Warning "This package requires at least Windows Server 2019 1809/OS build 17763.x."
    throw
   }
