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
    $regex  = 'jenkins-.+\.zip$'
    $url = $page.links | Where-Object href -match $regex | Select-Object -Last 1 -expand href
    $version = ([Regex]::Matches($url, '(\d+\.\d+.\d+)+')).Value

    return @{
        URL   = "http://mirrors.jenkins-ci.org/windows-stable/$url"
        Version = $version
    }
}

update -ChecksumFor 32
