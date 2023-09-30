#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://www.ntwind.com/software/alttabter.html'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'              = "`$1'$($Latest.URL32)'"
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
    $regex = '/download/AltTabTer_(?<version>[\d\.]+)-setup.exe'
    $url = $page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href
    $version = $matches.version

    return @{
        URL32   = $url
        Version = ConvertTo-VersionNumber -Version ([version]$version) -Part 3
    }
}

update -ChecksumFor none