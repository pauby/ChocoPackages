. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'TranslucentTB'
$repoName = 'TranslucentTB'


function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^[$]version\s*=\s*)('.*')"     = "`$1'$($Latest.Version)'"
        }
    }
}

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge
    Rename-Item -Path 'tools\bundle_x32.msixbundle' -NewName 'translucenttb.msixbundle'
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

    $asset32 = $release.assets | Where-Object name -eq 'bundle.msixbundle'
    $releaseNotes = if ([string]::IsNullOrEmpty($release.body)) {
        $release.html_url
    }
    else {
        $release.body
    }

    return @{
        Asset32      = $asset32
        URL32        = $asset32.browser_download_url
        Version      = $version
        ReleaseNotes = $releaseNotes
    }
}

Update-Package -ChecksumFor none