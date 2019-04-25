$packageName = 'adobeshockwaveplayer'
$checksum = 'BB5A21A38919483E25F8C84F51E5FD426CA96F061060FA096CD9520687E73B7E'
$checksumType = 'sha256'
$installerType = 'exe'
$silentArgs = '/S /NCRC'
$validExitCodes = @(0)

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$installFile = Join-Path $toolsDir "$($packageName).exe"
Import-Module (Join-Path "$toolsDir" 'Get-HtmlFromRegex.psm1')

$urlAppId = 'https://filehippo.com/download_shockwave/download/cac7bf9138874f29ccab21667ac2510c/'
$search = 'download_shockwave/download/([\w\d]+)/'
$replace = 'https://www.filehippo.com/en/download_shockwave/download/$1/'
$urlTemp = Get-HtmlFromRegex $urlAppId $search $replace
$search = '/download/file/([\w\d]+)/'
$replace = 'https://www.filehippo.com/download/file/$1/'
$url = Get-HtmlFromRegex $urlTemp $search $replace

Start-Process 'AutoHotKey' $ahkFile
Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType"