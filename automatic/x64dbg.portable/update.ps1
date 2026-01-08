. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'x64dbg'
$repoName = 'x64dbg'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        }
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$archiveFilename\s*=\s*)(''.*'')' = "`${1}'$($Latest.Asset32.name)'"
        }
        ".\tools\VERIFICATION.txt"      = @{
            "(^\s*x86 URL:\s*)(.*)"           = "`${1} $($Latest.URL32)"
            "(^\s*x86 Checksum:\s*)(.*)"      = "`${1} $($Latest.Checksum32)"
            "(^\s*x86 Checksum Type:\s*)(.*)" = "`${1} $($Latest.ChecksumType32)"
        }
    }
}

function global:au_BeforeUpdate {
    Remove-Item -Path 'tools\*.zip' -Force
    Invoke-WebRequest -Uri $Latest.URL32 -OutFile "tools\$($Latest.Asset32.name)"

    $Latest.ChecksumType32 = 'SHA256'
    $Latest.Checksum32 = (Get-FileHash -Path "tools\$($Latest.Asset32.name)" -Algorithm $Latest.ChecksumType32).Hash
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {

    $release = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Latest

    $asset32 = $release.assets | Where-Object name -Match '^snapshot_.*\.zip$'

    # The version number format is taken from the original packagers' update.ps1. This isn't the way I'd do it.
    # https://github.com/echizenryoma/Chocolatey-Package/blob/8d7539b2abc4e8bb62e43af50dd2e7c6d6bddfa4/x64dbg.portable/update.ps1#L19C64-L19C151
    # $base = "https://sourceforge.net/projects/x64dbg/files/snapshots/"
    # $page = Invoke-WebRequest -UseBasicParsing -Uri $base
    # $url32 = ($page.Links.href -match "snapshot_.*\/download")[0] -replace "/download", ""
    # $version = ([IO.Path]::GetFileNameWithoutExtension($url32) -split "\.|_" -match "\d+(-\d+)+$" -replace "-", "" | Select-Object -First 2) -join "."
    $version = ($asset32.name -split "\.|_" -match "\d+(-\d+)+$" -replace "-", "" | Select-Object -First 2) -join "."
    $releaseNotes = $release.html_url

    return @{
        Asset32      = $asset32
        URL32        = $asset32.browser_download_url
        Version      = ConvertTo-VersionNumber -Version ([version]$version) -Part 3
        ReleaseNotes = $releaseNotes
    }
}

Update-Package -ChecksumFor None


