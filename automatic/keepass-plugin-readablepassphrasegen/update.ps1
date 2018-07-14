#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://bitbucket.org/ligos/readablepassphrasegenerator/wiki/Home'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
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
    $regexUrl = 'Version (?<version>[\d\.]+)'

    $null = $page.content -match $regexUrl
    $version = $matches.version
    $url = "https://bitbucket.org/ligos/readablepassphrasegenerator/downloads/ReadablePassphrase%20$version.plgx"

    return @{
        URL32        = $url
        Version      = $matches.version
    }
}

update -ChecksumFor none