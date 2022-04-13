#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://api.github.com/repos/languagetool-org/languagetool/tags'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'              = "`$1'$($Latest.URL32)'"
            # "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            # "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
            "(?i)(^\s*specificFolder\s*=\s*)('.*')" = "`$1'LanguageTool-$($Latest.Version)'"
        }
    }
}

function global:au_BeforeUpdate() {
    #$Latest.Checksum32 = Get-RemoteChecksum -Url $Latest.URL32 -Algorithm 'SHA256'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $latestTag = (Invoke-RestMethod -Uri $releases -UseBasicParsing) | Select-Object -First 1 -Property name
    if (-not ($latestTag -match '[\d\.]+')) {
        return
    }

    $version = $matches[0]
    $url = ("https://languagetool.org/download/LanguageTool-{0}.zip" -f $version)
    return @{
        URL32   = $url
        Version = $version
    }
}

Update-Package -ChecksumFor None