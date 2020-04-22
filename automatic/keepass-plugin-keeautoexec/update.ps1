#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://keepass.info/plugins.html'

function global:au_SearchReplace {
    @{}
}

function global:au_BeforeUpdate {
    $filename = "tools\keepass-plugin-keeautoexec.zip"
    Invoke-WebRequest -Uri $Latest.URL -UseBasicParsing -OutFile $filename
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = 'extensions/v2/keeautoexec/KeeAutoExec-(?<version>[\d\.]+).zip'
    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href

    return @{
        URL   = "https://keepass.info/$url"
        Version = $matches.version
    }
}

update -ChecksumFor none