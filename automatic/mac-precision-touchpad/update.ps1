#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'imbushuo'
$repoName = 'mac-precision-touchpad'

function global:au_SearchReplace {
    @{}
}

function global:au_BeforeUpdate {
    do {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid().ToString())
    }
    while (Test-Path -Path $tempPath)

    $filename = "$tempPath.zip"
    Invoke-WebRequest -Uri $Latest.URL64 -UseBasicParsing -OutFile $filename
    Expand-Archive -Path $filename -Destination "tools" -Force
}

# This was failing which may have been failing the build.
# function global:au_AfterUpdate {
#     Set-DescriptionFromReadme -SkipFirst 2
# }

function global:au_GetLatest {

    $release = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Latest
    $version = ("0.{0}" -f $release.tag_name.replace('-', '.'))
    if ($version.StartsWith('v')) {
        $version = $version.Substring(1)    # skip over 'v' in tag
    }

    $asset64 = $release.assets | Where-Object name -eq 'Drivers-amd64-ReleaseMSSigned.zip'
    $releaseNotes = if ([string]::IsNullOrEmpty($release.body)) {
        $release.html_url
    }
    else {
        $release.body
    }

    return @{
        Asset64      = $asset64
        URL64        = $asset64.browser_download_url
        Version      = $version
        ReleaseNotes = $releaseNotes
    }
}

Update-Package -ChecksumFor none