#import-module au
Import-Module PowerShellForGitHub

. $PSScriptRoot\..\..\scripts\all.ps1

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\$zipFile\s*=\s*)(''.*'')'           = "`$1'$($Latest.Filename)'"
        }
    }
}

function global:au_BeforeUpdate {
    Get-GitHubReleaseAsset -OwnerName gohugoio -RepositoryName hugo -Asset $Latest.ReleaseAssetID -Path "tools\$($Latest.Filename)" -Force
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $release = Get-GitHubRelease -OwnerName gohugoio -RepositoryName hugo -Latest
    $version = $release.tag_name
    if ($version.StartsWith('v')) {
        $version = $version.Substring(1)    # skip over 'v' in tag
    }

    $asset = Get-GitHubReleaseAsset -OwnerName gohugoio -RepositoryName hugo -Release $release.id | Where-Object name -match "hugo_extended_$($version)_windows-amd64.zip"
    $url = $asset.browser_download_url

    return @{
        ReleaseAssetID = $asset.id
        Filename       = $asset.name
        URL64          = $url
        Version        = $version
    }
}

Update-Package -ChecksumFor none