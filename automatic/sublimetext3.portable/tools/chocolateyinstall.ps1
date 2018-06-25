$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = 'https://download.sublimetext.com/Sublime%20Text%20Build%203176.zip'
    checksum       = 'F35A2D4D93E77E4104A75DCABEE051F8C29F6C746FD7C937B07F2CE192B92C27'
    checksumType   = 'SHA256'

    url64          = 'https://download.sublimetext.com/Sublime%20Text%20Build%203176%20x64.zip'
    checksum64     = '5D1FDD06C0C21054EC384827B6ED6455B9A7E05C58A9F3716159904BCD382911'
    checksumType64 = 'SHA256'
    unzipLocation  = $toolsdir
}

# Some of this was taken from https://github.com/brianmego/Chocolatey/pull/6
Install-ChocolateyZipPackage @packageArgs

# Start menu shortcuts
$progsFolder = [Environment]::GetFolderPath('Programs')
If ( Test-ProcessAdminRights ) {
    $progsFolder = [Environment]::GetFolderPath('CommonPrograms') 
}

Install-ChocolateyShortcut -shortcutFilePath (Join-Path -Path $progsFolder -ChildPath 'Sublime Text 3 Portable.lnk') `
    -targetPath (Join-Path -Path $toolsDir -ChildPath "sublime_text.exe")