#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://www.yubico.com/products/services-software/download/yubikey-personalization-tools/'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'              = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = "yubikey-personalization-gui-(?<Version>[\d\.]+).exe$"

    $url32 = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href

    return @{
        URL32   = $url32
        Version = $matches.Version
    }
}

update -ChecksumFor all