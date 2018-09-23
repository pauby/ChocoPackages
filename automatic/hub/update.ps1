#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://github.com/github/hub/releases'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'                = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"         = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"     = "`$1'$($Latest.ChecksumType32)'"

            '(^\s*url64\s*=\s*)(''.*'')'              = "`$1'$($Latest.URL64)'"
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
    $regexUrl = '/download/v(?<version>[\d\.]+)/hub-windows-'
    $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href
    $version = $matches.version

    return @{
        URL32        = "https://github.com/github/hub/releases/download/v$version/hub-windows-386-$version.zip"
        URL64        = "https://github.com/github/hub/releases/download/v$version/hub-windows-amd64-$version.zip"
        Version      = $version
    }
}

update -ChecksumFor all