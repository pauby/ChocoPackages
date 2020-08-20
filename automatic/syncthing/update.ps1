#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://github.com/syncthing/syncthing/releases/latest'

function global:au_SearchReplace {
    @{
    }
}

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = 'syncthing-windows-386-v(?<version>.*).zip'

    $url32 = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href
    $version = $matches.version
    $url64 = $url32 -replace '-386-', '-amd64-'

    return @{
        URL32   = "https://github.com/$url32"
        URL64   = "https://github.com/$url64"
        Version = $version
        PayloadVersion = $version
    }
}

update -ChecksumFor none