#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

Import-Module PowerShellForGitHub

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
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
    $release = Get-GitHubRelease -OwnerName gohugoio -RepositoryName hugo -Latest
    $version = $release.tag_name
    if ($version.StartsWith('v')) {
        $version = $version.Substring(1)    # skip over 'v' in tag
    }

    $url = (Get-GitHubReleaseAsset -OwnerName gohugoio -RepositoryName hugo -Release $release.id | Where-Object name -EQ "hugo_$($version)_windows-amd64.zip").browser_download_url

    return @{
        URL64   = $url
        Version = $version
    }
}

update -ChecksumFor 64