#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://s3browser.com/' # no trailing slash!

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexurl = "window.location='https://s3browser.com/download/s3browser-(?<version>[\d-]+).exe'"
    $page.content -match $regexUrl

    return @{
        URL32 = ("{0}/download/s3browser-{1}.exe" -f $releases, $matches.version)
        Version = $matches.version.Replace("-", ".")
    }
}

Update-Package -ChecksumFor 32