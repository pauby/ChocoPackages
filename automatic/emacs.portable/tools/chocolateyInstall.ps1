$ErrorActionPreference = 'Stop'

$softwareVersion = '29.4'
$zipFile = "emacs-$($softwareVersion)_x64.zip"

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$filePath = Join-Path -Path $toolsDir -ChildPath $zipFile
$installPath = Join-Path -Path (Get-ToolsLocation) -ChildPath 'emacs'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $installPath
    fileFullPath   = $filePath
}

Get-ChocolateyUnzip @packageArgs

# # if the 'emacs' folder doesn't exist then simply rename the extracted folder to 'emacs'.
# # if it does exist, overwrite the contents with the extracted folders contents.
# # Note that we don't want to remove that folder and replace it with this one as they could have added files
# # into the emacs folder they want to keep
# $extractedFolder = Join-Path -Path (Get-ToolsLocation) -ChildPath "emacs-$softwareVersion"
# if (Test-Path -Path $installPath) {
#     # if we get here the emacs folder exists so we need to copy the files into it
#     Copy-Item -Path "$extractedFolder\*.*" -Destination $installPath -Recurse -Force

#     # once we have copied all of the files out of it, remove the folder as we no longer need it
#     Remove-Item -Path $extractedFolder -Recurse -Force
# }
# else {
#     # if we get here the emacs folder does not exist so we just rename our extracted folder
#     Rename-Item -Path $extractedFolder -NewName 'emacs'
# }

# Exclude executables from getting shimmed
'runemacs', 'emacsclientw' | Foreach-Object { Install-BinFile -Name $_ -Path (Join-Path -Path $installPath -ChildPath "bin\$($_).exe") -UseStart }
'emacs', 'emacsclient' | Foreach-Object { Install-BinFile -Name $_ -Path (Join-Path -Path $installPath -ChildPath "bin\$($_).exe") }
