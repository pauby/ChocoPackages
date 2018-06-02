#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://github.com/Yubico/yubioath-desktop/releases/latest'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'              = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
            '(^\s*url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"

        }
    }
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = "/yubioath-desktop-(?<version>[\d\.]+)-win\d{2}.exe$"

    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -First 2 -expand href
    $url32 = $url | Where-Object { $_ -like '*win32.exe' }
    $url64 = $url | Where-Object { $_ -like '*win64.exe' }

    return @{
        URL32   = "https://github.com/$url32"
        URL64   = "https://github.com/$url64"
        Version      = $matches.version
    }
}

update -ChecksumFor all