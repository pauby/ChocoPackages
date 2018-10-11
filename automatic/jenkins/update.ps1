import-module au

$releases = 'https://jenkins.io/download/'

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
    $regexUrl = "Deploy Jenkins`n(?<version>[\d\.]+)"
    $page.RawContent -match $regexUrl
    $version = $matches.version

    return @{
        URL   = "http://mirrors.jenkins-ci.org/windows-stable/jenkins-$version.zip"
        Version = $version
    }
}

update -ChecksumFor 32
