#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://update.vivaldi.com/update/1.0/public/appcast.x64.xml'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"            = "`$1'$($Latest.url32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"

            "(?i)(^\s*url64bit\s*=\s*)('.*')"         = "`$1'$($Latest.url64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = 'sparkle:version="(?<version>[\d\.]+)"'
    if ($page -notmatch $regexUrl) {
        throw "Couldn't find a version using regex ($regexUrl)."
    }

    $version = $matches.version
    $url32 = ('https://downloads.vivaldi.com/stable-auto/Vivaldi.{0}.exe' -f $version)
    $url64 = ('https://downloads.vivaldi.com/stable-auto/Vivaldi.{0}.x64.exe' -f $version)

    return @{
        URL32   = $url32
        URL64   = $url64
        Version = $version
    }
}

update -ChecksumFor all