$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$executable = "client.bat"
$zip32Filename = 'acr_v2.18.2-w.zip'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileFullPath   = Join-Path -Path $toolsdir -ChildPath $zip32Filename
    Destination    = $toolsDir
}

Get-ChocolateyUnZip @packageArgs
Install-ChocolateyShortcut -ShortcutFilePath (Join-Path -Path $env:ALLUSERSPROFILE -ChildPath "Microsoft\Windows\Start Menu\Programs\AC Reloaded.lnk") `
	-TargetPath (Join-Path -Path $packageArgs.unzipLocation -ChildPath $executable) `
	-WorkingDirectory $toolsdir
