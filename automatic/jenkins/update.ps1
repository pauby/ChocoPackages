#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'http://mirrors.jenkins-ci.org/windows-stable/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*url\s*=\s*)('.*')"             = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"        = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $pageFiltered = $page.links | Where-Object href -match '\.zip$' | Select-Object -Last 1 -expand href

    $regexUrl = 'jenkins-(?<version>[\d\.]+).zip$'
    $pageFiltered -match $regexUrl
    $version = $matches.version

    return @{
        URL   = "http://mirrors.jenkins-ci.org/windows-stable/jenkins-$version.zip"
        Version = $version
    }
}

update -ChecksumFor 32
