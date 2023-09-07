$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$versPath = 'vim90'
#$filename32 = "$toolsDir\complete-x86.7z"
$filename64 = "$toolsDir\complete-x64.7z"

# pckage parameter defaults
$destDir = Join-Path -Path $toolsDir -ChildPath $versPath

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
#    fileFullPath   = $filename32
    fileFullPath64 = $filename64
    destination    = $destDir
}

Get-ChocolateyUnzip @packageArgs

(Get-Item $destdir\patch.exe).LastWriteTime = (Get-Date) # exe must be newer than manifest; Supplied manifest fixes useless UAC request

# Rather than letting the installer place the batch files in C:\WINDOWS, they are included them in this package.
# They are taken from C:\Windows on a default installation of vim-tux (or the vim-tux.install package).
# Installing them in this way ensures the package is compatible with non-admin installs, as a good portable package should :)
Get-ChildItem "$destDir\*.bat" | ForEach-Object {
    Install-BinFile -Name $_.BaseName -Path $_
}

# Set the VIM environment variable for the batch files to work. Note that it's the prent directory of the VIM90 folder.
# As this is a poetable package, the user may not have admin rights. Therefore, the variable scope should be 'User'
Install-ChocolateyEnvironmentVariable -VariableName 'VIM' -VariableValue $toolsDir -VariableType 'User'

#$filename32,
$filename64 | Remove-Item -Force -ErrorAction SilentlyContinue
Write-Host 'Build provided by TuxProject.de - consider donating to help support their server costs.'
