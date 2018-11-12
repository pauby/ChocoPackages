#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://github.com/gohugoio/hugo/releases'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = '/hugo_(?<version>[\d\.]+)_Windows-64bit\.zip'

    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href

    return @{
        URL64        = "https://github.com/$url"
        Version      = $matches.version
    }
}

update -ChecksumFor 64