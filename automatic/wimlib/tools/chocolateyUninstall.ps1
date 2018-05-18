
$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    zipFileName   = "wimlib-$($env:ChocolateyPackageVersion)-windows-x86_64-bin.zip"
}

(Get-ChildItem -Path (Join-Path -Path $toolsDir -ChildPath $env:ChocolateyPackageName) -Filter '*.cmd').ForEach( {
    Uninstall-BinFile -Name $_.BaseName
} )

Uninstall-ChocolateyZipPackage @packageArgs