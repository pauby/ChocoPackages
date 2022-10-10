#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

Import-Module PowerShellForGitHub
Set-GitHubConfiguration -DisableTelemetry

$repoOwner = 'syncthing'
$repoName = 'syncthing'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$zip32Filename\s*=\s*)(''.*'')' = "`$1'$($Latest.Filename32)'"
            '(^\s*\$zip64Filename\s*=\s*)(''.*'')' = "`$1'$($Latest.Filename64)'"
        }
    }
}

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge
    Get-GitHubReleaseAsset -OwnerName $repoOwner -RepositoryName $repoName -Asset $Latest.ReleaseAsset32ID -Path "tools\$($Latest.Filename32)" -Force
    Get-GitHubReleaseAsset -OwnerName $repoOwner -RepositoryName $repoName -Asset $Latest.ReleaseAsset64ID -Path "tools\$($Latest.Filename64)" -Force
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

    $asset = Get-GitHubReleaseAsset -OwnerName $repoOwner -RepositoryName $repoName -Release $release.id
    $asset32 = $asset | Where-Object name -match 'syncthing-windows-386-v(?<version>.*).zip'
    $asset64 = $asset | Where-Object name -Match 'syncthing-windows-amd64-v(?<version>.*).zip'

    return @{
        ReleaseAsset32ID = $asset32.id
        ReleaseAsset64ID = $asset64.id
        Filename32       = $asset32.name
        Filename64       = $asset64.name
        URL32            = $asset32.browser_download_url
        URL64            = $asset64.browser_download_url
        Version          = $version
    }




    # $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    # $regexUrl = 'syncthing-windows-386-v(?<version>.*).zip'

    # $url32 = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href
    # $version = $matches.version
    # $url64 = $url32 -replace '-386-', '-amd64-'

    # return @{
    #     URL32   = "https://github.com/$url32"
    #     URL64   = "https://github.com/$url64"
    #     Version = $version
    #     PayloadVersion = $version
    # }
}

Update-Package -ChecksumFor none