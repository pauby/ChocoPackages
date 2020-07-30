#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://github.com/andrew-schofield/keepass2-haveibeenpwned/releases/latest'

function global:au_SearchReplace {
    @{}
}

function global:au_BeforeUpdate {
    Invoke-WebRequest -Uri $Latest.URL32 -UseBasicParsing -OutFile 'tools\HaveIBeenPwned.plgx'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = '/download/v(?<version>[\d\.]+)/HaveIBeenPwned.plgx$'
    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href

    return @{
        URL32   = "https://github.com/$url"
        Version = $matches.version
    }
}

Update-Package -ChecksumFor none