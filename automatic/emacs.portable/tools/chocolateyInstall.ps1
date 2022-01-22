$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$filePath = Get-Item -Path (Join-Path -Path $toolsDir -ChildPath 'emacs-*.zip')
$installPath = Join-Path -Path (Get-ToolsLocation) -ChildPath 'emacs'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $installPath
    fileFullPath   = $filePath
}

Get-ChocolateyUnzip @packageArgs

# Exclude executables from getting shimmed
'runemacs', 'emacsclientw' | Foreach-Object { Install-BinFile -Name $_ -Path (Join-Path -Path $installPath -ChildPath "bin\$($_).exe") -UseStart }
'emacs', 'emacsclient' | Foreach-Object { Install-BinFile -Name $_ -Path (Join-Path -Path $installPath -ChildPath "bin\$($_).exe") }