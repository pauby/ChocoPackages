. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = "Nexus-Mods"
$repoName = "Vortex"

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        }

        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$fileLocation\s*=\s*)(''.*'')' = "`$1'$($Latest.Asset32.name)'"
        }

        ".\legal\VERIFICATION.txt"      = @{
            "(?i)(^\s*location on\:?\s*)\<.*\>" = "`${1}<$($Latest.ReleaseUri)>"
            "(?i)(^\s*url(32)?\:\s*).*"         = "`${1}<$($Latest.URL32)>"
            "(?i)(^\s*checksum(32)?\:\s*).*"    = "`${1}$($Latest.Checksum32)"
            "(?i)(^\s*checksum\s*type\:\s*).*"  = "`${1}$($Latest.ChecksumType32)"
        }
    }
}

function global:au_BeforeUpdate($Package) {
    Remove-Item -Path 'tools\*.exe' -Force -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri $Latest.URL32 -OutFile "tools\$($Latest.Asset32.name)"
    $Latest.ChecksumType32 = 'SHA256'
    $Latest.Checksum32 = (Get-FileHash -Path "tools\$($Latest.Asset32.name)" -Algorithm $Latest.ChecksumType32).Hash
}

function global:au_AfterUpdate($Package) {
}

function global:au_GetLatest {
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

    $asset32 = $release.assets | Where-Object name -Match '\.exe$' | Select-Object -First 1

    return @{
        Version      = $version
        URL32        = $asset32.browser_download_url
        Asset32      = $asset32
        ReleaseUri   = $release.latest.ReleaseUrl
        ReleaseNotes = $releaseNotes
    }

    return $Latest
}

update -ChecksumFor none
