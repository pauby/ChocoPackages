. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://keepass.info/download.html'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"$($Latest.Version)`""
        }
    }
}

function global:au_BeforeUpdate() { }

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $version = (choco search keepass.install --exact --by-id-only --limit-output | ConvertFrom-Csv -Delimiter '|' -Header 'name', 'version').version

    return @{
        Version = ConvertTo-VersionNumber -Version ([version]$version) -Part 3
    }
}

Update-Package -ChecksumFor None
