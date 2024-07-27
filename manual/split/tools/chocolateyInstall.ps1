$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName     = 'split'
    url             = 'https://www.pc-tools.net/files/win32/freeware/splt3210.zip'
    unzipLocation   = $toolsDir
    checksum        = 'fc94af991b5dc02c6a038b2270fe9ee94a4d52c0'
    checksumType    = 'sha1'
}

Install-ChocolateyZipPackage @packageArgs

$installFile = Join-Path $toolsDir "$($packageName).exe"
Set-Content -Path ("$installFile.gui") -Value $null