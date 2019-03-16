$ErrorActionPreference = 'Stop'

$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$exeFilename   = 'HousecallLauncher64.exe'
$destPath      = (Join-Path -Path $toolsDir -ChildPath $exeFilename)

$packageArgs = @{
    packageName      = $env:ChocolateyPackageName
    fileFullPath     = $destPath
    url64            = 'https://go.trendmicro.com/housecall8/r2/HousecallLauncher64.exe'
    checksum64       = '037EF62A9FB4E159AD46E2F0B40BB752EA5085B7E9107EFFB430AE580D82BBFA'
    checksumType64   = 'SHA256' #default is md5, can also be sha1, sha256 or sha512
}
write-host "toolsdit: $toolsdir"
Get-ChocolateyWebFile @packageArgs
Add-BinFile -Name 'housecall' -Path $destPath