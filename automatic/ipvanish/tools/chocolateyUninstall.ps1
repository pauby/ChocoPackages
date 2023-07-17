$ErrorActionPreference = 'Stop' # stop on all errors

$toolsDir       = $(Split-Path -Parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    softwareName    = 'IPVanish*'  #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
    fileType        = 'EXE'
    # the installer always seems to exit with -1. ALWAYS! This is a really bad idea but I don't know what else to do here.
    validExitCodes  = @(-1, 0, 3010, 1605, 1614, 1641)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
    $uninstallStringParts = $key[0].UninstallString -split ' /'
    $uninstallerPath = $uninstallStringParts[0].Trim('"')
    $uninstallerArgs = "/$($uninstallStringParts[1].Trim(' '))"   # we split on the '/' so add it back in
}
elseif ($key.Count -eq 0) {
    Write-Warning "$packageName has already been uninstalled by other means."
    return
}
elseif ($key.Count -gt 1) {
    # This installer creates MSI and EXE uninstaller keys:
    # MsiExec.exe /X{13C893E2-C294-43D3-93A7-2FB25245E7BE}
    # "C:\ProgramData\Package Cache\{9fbdf1aa-07db-4cda-bbac-9bed297bd2c2}\IPVanish.exe"  /uninstall
    # We need to find the correct string
    for ($i = 0; $i -lt $key.Count; $i++) {
        if ($key[$i].UninstallString -like '*IPVanish.exe*') {
            break
        }
    }

    # The string will look something like 
    # "C:\ProgramData\Package Cache\{9fbdf1aa-07db-4cda-bbac-9bed297bd2c2}\IPVanish.exe"  /uninstall
    # so first part will be uninstall path and second part will be arguments.
    $uninstallStringParts = $key[$i].UninstallString -split ' /'
    $uninstallerPath = $uninstallStringParts[0].Trim('"')
    $uninstallerArgs = "/$($uninstallStringParts[1].Trim(' '))"   # we split on the '/' so add it back in
}

# Start Autohotkey uninstall script
$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path -Path $env:TEMP -ChildPath "$(Get-Random).ahk" 
$ahkSourceFile = Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)-uninstall.ahk"
Copy-Item -Path $ahkSourceFile -Destination $ahkFile

Write-Verbose "Running AutoHotkey install script $ahkFile"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

$packageArgs['file'] = $uninstallerPath
$packageArgs['silentArgs'] = $uninstallerArgs

Uninstall-ChocolateyPackage @packageArgs