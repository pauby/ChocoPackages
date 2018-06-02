#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://update.gitter.im/win/latest'

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
    $regexUrl = "GitterSetup-(.*).exe"

    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href  
    $version = $matches[1]

    return @{
        URL32        = $url
        Version      = $version
    }
}

update -ChecksumFor 32