#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'github'
$repoName = 'hub'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'                = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"         = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"     = "`$1'$($Latest.ChecksumType32)'"

            '(^\s*url64\s*=\s*)(''.*'')'              = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate {
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {

    $release = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Latest
    $version = $release.tag_name
    if ($version.StartsWith('v')) {
        $version = $version.Substring(1)    # skip over 'v' in tag
    }

    $asset32 = $release.assets | Where-Object name -Match "hub-windows-386-$($version).zip"
    $asset64 = $release.assets | Where-Object name -Match "hub-windows-amd64-$($version).zip"
    $releaseNotes = if ([string]::IsNullOrEmpty($release.body)) {
        $release.html_url
    }
    else {
        $release.body
    }

    return @{
        Asset32      = $asset32
        Asset64      = $asset64
        URL32        = $asset32.browser_download_url
        URL64        = $asset64.browser_download_url
        Version      = $version
        ReleaseNotes = $releaseNotes
    }
}

Update-Package -ChecksumFor all