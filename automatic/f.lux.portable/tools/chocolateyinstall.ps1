$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://justgetflux.com/flux-setup.exe'
    checksum       = '79FC802D9225D98EE15A288393BB2D4708575315B9EDAD33DBFCF29D1AF578B1'
    checksumType   = 'SHA256'
    unzipLocation  = $toolsdir
}

# Some of this was taken from https://github.com/brianmego/Chocolatey/pull/6
Install-ChocolateyZipPackage @packageArgs

# Start menu shortcuts
$progsFolder = [Environment]::GetFolderPath('Programs')
If ( Test-ProcessAdminRights ) {
    $progsFolder = [Environment]::GetFolderPath('CommonPrograms') 
}

Install-ChocolateyShortcut -shortcutFilePath (Join-Path -Path $progsFolder -ChildPath 'f.lux.lnk') `
    -targetPath "$($env:ChocolateyInstall)\lib\$packageName\tools\flux.exe" `
    -WorkingDirectory "$($env:ChocolateyInstall)\lib\$packageName\tools\runtime"

# only create the shortcut in startup if the /noautostart parameter has not been passed
$arguments = Get-PackageParameters -Parameter $env:ChocolateyPackageParameters
if (-not $arguments.ContainsKey("noautostart")) {
    Write-Verbose "Setting to autostart with Windows."
    $params = @{
        ShortcutFilePath = Join-Path -Path $progsFolder -ChildPath 'Startup\f.lux.lnk'
        TargetPath       = "$($env:ChocolateyInstall)\lib\$packageName\tools\flux.exe"
        WorkingDirectory = "$($env:ChocolateyInstall)\lib\$packageName\tools\runtime"
        Arguments        = '/noshow'
    }

    Install-ChocolateyShortcut @params
}