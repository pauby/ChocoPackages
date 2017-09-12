$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$ahkFile = 'ad-awarefreeantivirus_uninstall.ahk'
$ahkPath = $(Join-Path -Path $toolsDir -ChildPath $ahkFile)

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    softwareName   = 'adaware antivirus*'
    fileType       = 'EXE'
    silentArgs     = ''
    validExitCodes = @(0)
}

$uninstalled = $false

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

$ahkRun = "$Env:Temp\$(Get-Random).ahk"
Write-Debug "AHK file to run: $ahkrun"
Copy-Item $ahkPath $ahkRun -Force
$ahkProc = Start-Process -FilePath 'AutoHotKey' `
    -ArgumentList $ahkRun `
    -PassThru

$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

if ($key.Count -eq 1) {
    $key | ForEach { 
        if ($_.UninstallString -match '"(.*)"\s(.*)') {
            $packageArgs['file'] = $matches[1]
            $packageArgs['silentArgs'] = $matches[2]
        }

        if ($packageArgs['fileType'] -eq 'MSI') {
            $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
            $packageArgs['file'] = ''
        }

        Uninstall-ChocolateyPackage @packageArgs
    }
}
elseif ($key.Count -eq 0) {
    Write-Warning "$packageName has already been uninstalled by other means."
}
elseif ($key.Count -gt 1) {
    Write-Warning "$($key.Count) matches found!"
    Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
    Write-Warning "Please alert package maintainer the following keys were matched:"
    $key | % {Write-Warning "- $($_.DisplayName)"}
}

Remove-Item "$ahkRun" -Force