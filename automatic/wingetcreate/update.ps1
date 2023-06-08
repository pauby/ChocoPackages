#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'microsoft'
$repoName = 'winget-create'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        }
        ".\tools\VERIFICATION.txt"      = @{
            "(^\s*64-bit URL:\s*)(.*)"           = "`$1$($Latest.URL64)"
            "(^\s*64-bit Checksum Type:\s*)(.*)" = "`$1$($Latest.ChecksumType64)"
            "(^\s*64-bit Checksum:\s*)(.*)"      = "`${1}$($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate {
    Remove-Item -Path 'tools\*.exe' -Force
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

    $asset64 = $release.assets | Where-Object name -Match "wingetcreate.exe$"
    $releaseNotes = if ([string]::IsNullOrEmpty($release.body)) {
        $release.html_url
    }
    else {
        $release.body
    }

    return @{
        Asset64        = $asset64
        URL64          = $asset64.browser_download_url
        Version        = $version
        ReleaseNotes   = $releaseNotes
    }
}

Update-Package -ChecksumFor None