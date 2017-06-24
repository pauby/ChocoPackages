$ErrorActionPreference = 'Stop';

$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$ahkFile = "$($env:ChocolateyPackageName)_uninstall.ahk"
$ahkPath = $(Join-Path -Path $toolsDir -ChildPath $ahkFile)

$packageArgs = @{
	packageName   = $env:ChocolateyPackageName
	softwareName  = 'yubico-authenticator*'
	fileType      = 'exe'
	silentArgs    = "/S" # NSIS

	validExitCodes= @(0)
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey @packageArgs

# Run Autohotkey
$ahkRun = Join-Path -Path $env:Temp -ChildPath "$(Get-Random).ahk"
Write-Verbose "Autohotkey file $ahkPath will be started as $ahkrun"
Copy-Item -Path $ahkPath -Destination $ahkRun -Force
$ahkProc = Start-Process -FilePath 'AutoHotKey' -ArgumentList $ahkRun -PassThru

if ($key.Count -eq 1) {
	$key | % { 
		$packageArgs['file'] = "$($_.UninstallString)"
		if ($packageArgs['fileType'] -eq 'MSI') {
		  $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
		  $packageArgs['file'] = ''
		}

		Uninstall-ChocolateyPackage @packageArgs
	}
} 
elseif ($key.Count -eq 0) {
	Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} 
elseif ($key.Count -gt 1) {
	Write-Warning "$key.Count matches found!"
	Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
	Write-Warning "Please alert package maintainer the following keys were matched:"
	$key | % {Write-Warning "- $_.DisplayName"}
}
