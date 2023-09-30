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

    $version = (choco search winget-cli --exact --by-id-only --limit-output | ConvertFrom-Csv -Delimiter '|' -Header 'name', 'version').version

    return @{
        Version = ConvertTo-VersionNumber -Version ([version]$version) -Part 3
    }
}

Update-Package -ChecksumFor None