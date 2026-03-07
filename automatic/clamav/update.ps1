#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'Cisco-Talos'
$repoName = 'clamav'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        }
        ".\tools\chocolateyInstall.ps1" = @{
            "(^\s*url64bit\s*=\s*)('.*')"         = "`${1}'$($Latest.URL64)'"
            "(^\s*checksum64\s*=\s*)('.*')"       = "`${1}'$($Latest.Checksum64)'"
            "(^\s*checksumType64\s*=\s*)('.*')"   = "`${1}'$($Latest.ChecksumType64)'"

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
    $versionTagPrefix = 'clamav-'
    if ($version.StartsWith($versionTagPrefix)) {
        $version = $version.Substring($versionTagPrefix.Length)    # skip over 'clamav-' in tag
    }

    $asset64 = $release.assets | Where-Object name -Match "clamav-$($version).win.x64.zip$"
    $releaseNotes = $release.html_url


    return @{
        Asset64        = $asset64
        URL64          = $asset64.browser_download_url
        Checksum64     = ($asset64.digest.Substring('sha256:'.Length))      # use GitHub SHA + remove 'sha256:' from it
        ChecksumType64 = 'SHA256'
        Version        = $version
        ReleaseNotes   = $releaseNotes
    }
}

Update-Package -ChecksumFor None