$ErrorActionPreference = 'Stop';

$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    softwareName   = "iris*" 
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path -Path $env:TEMP -ChildPath "$(Get-Random).ahk" 
$ahkSourceFile = Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)_uninstall.ahk"
Copy-Item -Path $ahkSourceFile -Destination $ahkFile

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs.softwareName
if ($key.Count -eq 1) {
    $key | % {
        $packageArgs.file = $_.UninstallString

        Write-Verbose "Running AutoHotkey install script $ahkFile"
        $ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
        $ahkId = $ahkProc.Id
        Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
        Write-Debug "Process ID:`t$ahkId"

        Uninstall-ChocolateyPackage @packageArgs
    }
}
elseif ($key.Count -eq 0) {
    Write-Warning "$packageName has already been uninstalled by other means."
}
elseif ($key.Count -gt 1) {
    Write-Warning "$key.Count matches found!"
    Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
    Write-Warning "Please alert package maintainer the following keys were matched:"
    $key | % {Write-Warning "- $_.DisplayName"}
}

Remove-Item $ahkFile -Force