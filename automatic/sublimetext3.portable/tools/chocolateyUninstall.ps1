$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$pkgPath = Split-Path -Path $toolsdir -Parent

[Environment]::GetFolderPath('Programs'), [Environment]::GetFolderPath('CommonPrograms') | ForEach-Object {
    Remove-Item -Path (Join-Path -Path $_ -ChildPath 'Sublime Text 3 Portable.lnk') -ErrorAction SilentlyContinue
}

# Remove the shim
Uninstall-BinFile -Name 'sublime_text'

# Remove the install
# get the name of the file created by Install-ChocolateyZipPackage
$zipFilename = (Get-Item -Path (Join-Path -Path $pkgPath -ChildPath '*.zip.txt') | Select-Object -First 1).Basename
Uninstall-ChocolateyZipPackage -PackageName 'sublimetext3.portable' -ZipFileName $zipFilename