. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'acreloaded'
$repoName = 'acr'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        }
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$zip32Filename\s*=\s*)(''.*'')' = "`$1'$($Latest.Asset32.name)'"
        }
        ".\tools\VERIFICATION.txt"      = @{
            "(^\s*x86 URL:\s*)(.*)"           = "`$1$($Latest.URL32)"
            "(^\s*x86 Checksum Type:\s*)(.*)" = "`$1$($Latest.ChecksumType32)"
            "(^\s*x86 Checksum:\s*)(.*)"      = "`${1}$($Latest.Checksum32)"
        }
    }
}

function global:au_BeforeUpdate() {
    Remove-Item -Path 'tools\*.zip' -Force -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri $Latest.URL32 -OutFile "tools\$($Latest.Asset32.name)"
    $Latest.ChecksumType32 = 'SHA256'
    $Latest.Checksum32 = (Get-FileHash -Path "tools\$($Latest.Asset32.name)" -Algorithm $Latest.ChecksumType32).Hash
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest
{
    $release = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Tag 'Latest'
    $version = $release.tag_name
    if ($version.StartsWith('v')) {
        $version = $version.Substring(1)    # skip over 'v' in tag
    }
    $releaseNotes = if ([string]::IsNullOrEmpty($release.body)) {
        $release.html_url
    }
    else {
        $release.body
    }

    $asset32 = $release.assets | Where-Object name -Match 'acr_(.*)-w.zip'

    return @{
        Asset32      = $asset32
        URL32        = $asset32.browser_download_url
        Version      = $version
        ReleaseNotes = $releaseNotes
    }
}

Update-Package -ChecksumFor none