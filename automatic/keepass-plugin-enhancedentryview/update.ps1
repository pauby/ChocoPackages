import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://sourceforge.net/projects/kpenhentryview/files'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $regex = 'v(?<version>[0-9.]+)/$'
    $url = ($page.links | Where-Object href -match $regex | Select-Object -First 1).href

    return @{
        URL32   = "https://sourceforge.net$($url)KPEnhancedEntryView-v$($matches.version).zip/download"
        Version = $matches.version
    }
}

update -ChecksumFor 32