$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    unzipLocation = Get-PackageCacheLocation
    url           = 'https://swtor-a.akamaihd.net/installer/SWTOR_setup.exe'
    checkum       = '3A1C68BE26461410651ECEA7DF1431D72276B3E22B3EFEADFE330BEC972455AC'
    checksumType  = 'sha256'
    fileType      = 'EXE'
    file          = Join-Path -Path (Get-PackageCacheLocation) -ChildPath "setup.exe"
    silentArgs    = ''
    # the setup spawns installer.exe to do the installation and exits with 2 for some reason.
    # it's a weird installer
    validExitCodes= @(0, 2)   
}

Write-Verbose "Downloading and extracting game setup into $($packageArgs.unzipLocation)"
Install-ChocolateyZipPackage @packageArgs

$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path -Path $toolsDir -ChildPath "$($env:ChocolateyPackageName)_install.ahk"
Write-Verbose "Running AutoHotkey install script $ahkFile"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

$lang = 'EN'
$installParams = Get-PackageParameters
if ($installParams.Language) {
    if ($installParams.Language -notin @('EN', 'DE', 'FR')) {
        Write-Warning "Invalid language specified. Must be: EN, DE or FR. Using default ($lang)"
    }
    else {
      $lang = $installParams.Language
      Write-Verbose "Using specified language ($lang)."
    }
}
else {
    Write-Verbose "No language specified. Using default ($lang)."
}

$packageArgs.silentArgs += " /LANGUAGE=$lang"

Install-ChocolateyInstallPackage @packageArgs -UseOnlyPackageSilentArguments