#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://iristech.co/iris/'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')"              = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
    # $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
    # $Latest.ChecksumType32 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regex = "Iris-(?<version>[\d\.]+).exe"

    $page.links | ForEach-Object {
        if ($_.OuterHTML -match $regex) {
            write-host "found regex"
            $version = $matches.version
            $url = $_.href
        }
    }

    if (-not (Test-Path -Path variable:url)) {
        throw "Could not match on the pattern and a URL was not found. Need to look at this package as the download page may have changed."
    }

    return @{
        URL32   = $url
        Version = $version
    }
}

Update-Package -ChecksumFor 32