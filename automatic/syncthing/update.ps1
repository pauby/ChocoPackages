#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'syncthing'
$repoName = 'syncthing'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$zip32Filename\s*=\s*)(''.*'')' = "`$1'$($Latest.Asset32.name)'"
            '(^\s*\$zip64Filename\s*=\s*)(''.*'')' = "`$1'$($Latest.Asset64.name)'"
        }
        ".\tools\VERIFICATION.txt"      = @{
            "(^\s*x86 URL:\s*)(.*)"           = "`$1$($Latest.URL32)"
            "(^\s*x86 Checksum Type:\s*)(.*)" = "`$1$($Latest.ChecksumType32)"
            "(^\s*x86 Checksum:\s*)(.*)"      = "`${1}$($Latest.Checksum32)"
            "(^\s*x64 URL:\s*)(.*)"           = "`$1$($Latest.URL64)"
            "(^\s*x64 Checksum Type:\s*)(.*)" = "`$1$($Latest.ChecksumType64)"
            "(^\s*x64 Checksum:\s*)(.*)"      = "`${1}$($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate() {
    Remove-Item -Path 'tools\*.zip'
    Invoke-WebRequest -Uri $Latest.URL32 -OutFile "tools\$($Latest.Asset32.name)"
    Invoke-WebRequest -Uri $Latest.URL64 -OutFile "tools\$($Latest.Asset64.name)"

    $Latest.ChecksumType32 = $Latest.ChecksumType64 = 'SHA256'
    $Latest.Checksum32 = (Get-FileHash -Path "tools\$($Latest.Asset32.name)" -Algorithm $Latest.ChecksumType32).Hash
    $Latest.Checksum64 = (Get-FileHash -Path "tools\$($Latest.Asset64.name)" -Algorithm $Latest.ChecksumType64).Hash
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {

    $release = Get-GitHubRelease -OwnerName $repoOwner -RepositoryName $repoName -Tag 'Latest'
    $version = $release.tag_name
    if ($version.StartsWith('v')) {
        $version = $version.Substring(1)    # skip over 'v' in tag
    }

    $asset32 = $release.assets | Where-Object name -match 'syncthing-windows-386-v(?<version>.*).zip'
    $asset64 = $release.assets | Where-Object name -Match 'syncthing-windows-amd64-v(?<version>.*).zip'

    return @{
        Asset32          = $asset32
        Asset64          = $asset64
        URL32            = $asset32.browser_download_url
        URL64            = $asset64.browser_download_url
        Version          = $version
        ReleaseNotes    = $release.body
    }
}

Update-Package -ChecksumFor none