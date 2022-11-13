#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'ihanson'
$repoName = 'KeePass-Rule-Builder'

function global:au_SearchReplace {
    @{}
}

function global:au_BeforeUpdate {
    Invoke-WebRequest -Uri $Latest.URL32 -UseBasicParsing -OutFile 'tools\RuleBuilder.dll'
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

    $asset32 = $release.assets | Where-Object name -eq 'RuleBuilder.dll'
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