$packageName    = 'dependency-server2016'

$IsWinServer=((Get-CimInstance Win32_OperatingSystem | Select-Object Caption) -match "Server")
if ($IsWinServer) {
  } else {
    Write-Warning "This package requires Windows Server 2016."
	throw
  }

$IsWinServer2016=[Environment]::OSVersion.Version.Major
if ($IsWinServer2016 -lt "10") 
   {
    Write-Warning "This package requires Windows Server 2016."
	throw
   }
