#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'izheil'
$repoName = 'Quantum-Nox-Firefox-Dark-Full-Theme'

function global:au_SearchReplace {
    @{}
}

function global:au_BeforeUpdate {
    Invoke-WebRequest -Uri $Latest.Url32 -UseBasicParsing -OutFile 'tools\quantum-nox.exe'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $release = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Latest

    $asset32 = $release.assets | Where-Object name -Match "Multirow-Patcher-Quantum-Nox-Installer-Windows-(?<version>[\d\.]+).exe"
    $version = $matches.version
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

Update-Package -ChecksumFor 32