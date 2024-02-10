$packageName    = 'dependency-server2016'

$IsWinServer=((Get-CimInstance Win32_OperatingSystem | Select-Object Caption) -match "Server")
if ($IsWinServer) {
  } else {
    Write-Warning "This package requires Windows Server 2016."
	throw
  }

$IsCorrectBuild=[Environment]::OSVersion.Version.Build
if ($IsCorrectBuild -lt "14393")
   {
    Write-Warning "This package requires at least Windows Server 2016 1607/OS build 14393.x."
    throw
   }
