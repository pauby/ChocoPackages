. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'jgm'
$repoName = 'pandoc'

function global:au_SearchReplace() {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        }
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$file64Filename\s*=\s*)(''.*'')' = "`$1'$($Latest.Asset64.name)'"
        }
        ".\tools\VERIFICATION.txt"      = @{
            "(^\s*x64 URL:\s*)(.*)"           = "`$1$($Latest.URL64)"
            "(^\s*x64 Checksum Type:\s*)(.*)" = "`$1$($Latest.ChecksumType64)"
            "(^\s*x64 Checksum:\s*)(.*)"      = "`${1}$($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate {
    Remove-Item -Path 'tools\*.msi' -Force
    Invoke-WebRequest -Uri $Latest.URL64 -OutFile "tools\$($Latest.Asset64.name)"

    $Latest.ChecksumType64 = 'SHA256'
    $Latest.Checksum64 = (Get-FileHash -Path "tools\$($Latest.Asset64.name)" -Algorithm $Latest.ChecksumType64).Hash
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

    $asset64 = $release.assets | Where-Object name -Match "pandoc-$($version)-windows-.*.msi"

    # the release notes for Pandoc have been very long. Just use the URL
    $releaseNotes = $release.html_url

    return @{
        Asset64      = $asset64
        Version      = $version
        URL64        = $asset64.browser_download_url
        ReleaseNotes = $releaseNotes
    }
}

Update-Package -ChecksumFor none
