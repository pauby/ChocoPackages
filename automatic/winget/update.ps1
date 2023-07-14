. $PSScriptRoot\..\..\scripts\all.ps1

$repoOwner = 'microsoft'
$repoName = 'winget-cli'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            '(\<dependency id="winget-cli" version=).*?( /\>)'    = "`$1""$($Latest.version)""`$2"
        }
    }
}

function global:au_BeforeUpdate {
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

    return @{
        Version        = ConvertTo-VersionNumber -Version ([version]$version) -Part 4
    }
}

Update-Package -ChecksumFor None