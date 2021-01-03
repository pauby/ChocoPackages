#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://github.com/ligos/readablepassphrasegenerator/releases/latest'

function global:au_SearchReplace {
    @{
    }
}


function global:au_BeforeUpdate() {
    Invoke-WebRequest -Uri $Latest.Url32 -UseBasicParsing -OutFile 'tools\ReadablePassphrase.plgx'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = 'ReadablePassphrase\.(?<version>[\d\.]+)\.plgx$'

    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -first 1 -expand href
    $version = $matches.version

    return @{
        URL32        = "https://github.com$url"
        Version      = $version
    }
}

update -ChecksumFor none
