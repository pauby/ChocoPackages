$ErrorActionPreference = 'Stop';

$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
	packageName   = $env:ChocolateyPackageName
	softwareName  = 'Yubico Authenticator*'
	fileType      = 'exe'
	silentArgs    = "/S" # NSIS

	validExitCodes= @(0)
}

# Run Autohotkey
$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path -Path $env:Temp -ChildPath "$(Get-Random).ahk"
$ahkSourceFile = Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)_uninstall.ahk"
Write-Verbose "Autohotkey file $ahkPath will be started as $ahkFile"
Copy-Item -Path $ahkSourceFile -Destination $ahkFile -Force | Out-Null

[array]$key = Get-UninstallRegistryKey @packageArgs
if ($key.Count -eq 1) {
    $key | ForEach-Object { 
        # some uninstall strings include parameters - remove them as we will use our own
        $packageArgs.file = "$($_.UninstallString)" -replace '/.*$', ''

        if ($packageArgs.fileType -eq 'MSI') {
            $packageArgs.silentArgs = "$($_.PSChildName) $($packageArgs.silentArgs)"
            $packageArgs.file = ''
        }

        Write-Verbose "Running AutoHotkey install script '$ahkFile'"
        $ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
        $ahkId = $ahkProc.Id
        Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
        Write-Debug "Process ID:`t$ahkId"

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
    $key | ForEach-Object {
        Write-Warning "- $_.DisplayName"
    }
}

Remove-Item $ahkFile -Force -ErrorAction SilentlyContinue