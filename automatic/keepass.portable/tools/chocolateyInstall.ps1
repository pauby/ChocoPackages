$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$installDir = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName
$pp = Get-PackageParameters
if ($pp["installPath"]) {
    $installDir = $pp["installPath"]
}

$packageArgs = @{
    packageName  = $env:ChocolateyPackageName
    fileFullPath = Join-Path -Path $toolsDir -ChildPath 'KeePass-Setup.zip'
    destination  = $installDir
}

Get-ChocolateyUnzip @packageArgs
Install-BinFile -Name 'keepass' -Path (Join-Path -Path $installDir -ChildPath 'keepass.exe')