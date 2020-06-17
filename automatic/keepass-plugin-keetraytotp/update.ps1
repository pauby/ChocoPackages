#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://github.com/KeeTrayTOTP/KeeTrayTOTP/releases'

function global:au_SearchReplace {
    @{
    }
}

function global:au_BeforeUpdate() {
    Invoke-WebRequest -Uri $Latest.Url32 -UseBasicParsing -OutFile 'tools\KeeTrayTOTP.plgx'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = '/v(?<version>[\d\.]+)/KeeTrayTOTP.plgx$'

    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -first 1 -expand href
    $version = $matches.version

    return @{
        URL32        = "https://github.com$url"
        Version      = $version
    }
}

Update-Package -ChecksumFor none
