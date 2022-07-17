$ErrorActionPreference = 'Stop'

$zipTextPath = Get-Item -Path (Join-Path -Path ($env:ChocolateyPackageFolder) -ChildPath 'emacs-*.zip.txt')

$packageArgs = @{
    packageName = $env:ChocolateyPackageName
    zipFilename = $zipTextPath.BaseName     # this is without the text file extension
}

Uninstall-ChocolateyZipPackage @packageArgs

'runemacs', 'emacsclientw', 'emacs', 'emacsclient' | ForEach-Object {
    Uninstall-BinFile -Name $_
}

Remove-Item -Path (Join-Path -Path (Get-ToolsLocation) -ChildPath 'emacs') -Recurse -Force
