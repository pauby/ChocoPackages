#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://developers.yubico.com/yubikey-piv-manager/Releases/'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = "yubikey-piv-manager-(?<version>[\d\.]+)(?<letter>[a-z]{1})*-win.exe$"

    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href
    if ($matches.letter) {
        $version = "{0}.{1}" -f $matches.version, [convert]::ToInt16([char]$matches.letter)
    }
    else {
        $version = "{0}.0" -f $matches.version
    }

    return @{
        URL32        = "https://developers.yubico.com/yubikey-piv-manager/Releases/$url"
        Version      = $version
    }
}

update -ChecksumFor 32