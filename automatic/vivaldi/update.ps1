#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://update.vivaldi.com/update/1.0/public/appcast.x64.xml'

function global:au_SearchReplace {
    @{
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = 'sparkle:version="(?<version>[\d\.]+)"'
    if ($page -notmatch $regexUrl) {
        throw "Couldn't find a version using regex ($regexUrl)."
    }

    $version = $matches.version

    return @{
        Version = $version
    }
}

update -ChecksumFor all