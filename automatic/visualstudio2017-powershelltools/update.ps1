#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

# the naming on the releases page doesn't conform to what we expect (one version
# was 'july-maintenance' for example) - use all of the releases page and just
# grab the last one that matches
$releases = 'https://github.com/adamdriscoll/poshtools/releases'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*vsixurl\s*=\s*)(''.*'')'          = "`$1'$($Latest.URL32)'"
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
    $regexUrl = '/download/v(?<version>.*)/PowerShellTools.15.0.vsix'

    $url32 = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href

    return @{
        URL32   = "https://github.com/$url32"
        Version = $matches.version
    }
}

update -ChecksumFor none