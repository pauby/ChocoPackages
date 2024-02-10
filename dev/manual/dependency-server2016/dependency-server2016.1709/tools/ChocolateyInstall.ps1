$packageName    = 'dependency-server2016'

$IsWinServer=((Get-CimInstance Win32_OperatingSystem | Select-Object Caption) -match "Server")
if ($IsWinServer) {
  } else {
    Write-Warning "This package requires Windows Server 2016."
	throw
  }

$IsCorrectBuild=[Environment]::OSVersion.Version.Build
if ($IsCorrectBuild -lt "16299")
   {
    Write-Warning "This package requires at least Windows Server 2016 1709/OS build 16299.x."
    throw
   }
