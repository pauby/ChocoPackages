$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://justgetflux.com/flux-setup.exe'
    checksum       = '79FC802D9225D98EE15A288393BB2D4708575315B9EDAD33DBFCF29D1AF578B1'
    checksumType   = 'SHA256'
    fileType       = 'EXE'
    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

# only create the shortcut in startup if the /noautostart parameter has not been passed
$arguments = Get-PackageParameters -Parameter $env:ChocolateyPackageParameters
if (-not $arguments.ContainsKey("noautostart")) {
    $params = @{
        ShortcutFilePath    = Join-Path -Path ([Environment]::GetFolderPath('Startup')) -ChildPath 'f.lux.lnk'
        TargetPath          = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'FluxSoftware\Flux\flux.exe'
        WorkingDirectory    = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'FluxSoftware\Flux\runtime'
        Arguments           = '/noshow'
    }
    
    Install-ChocolateyShortcut @params
}
