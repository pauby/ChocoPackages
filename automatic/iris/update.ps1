#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://iristech.co/iris/'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')"              = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
    $Latest.ChecksumType32 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $regexVer = "Iris-([\d\.]+).exe"
    if ($page.content -match $regexVer) { $version = $matches[1] }
    $url = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/Windows/Iris-$version.exe"

    return @{
        URL32   = $url
        Version = $version
    }
}

update -ChecksumFor none
