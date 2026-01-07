#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"$($Latest.Version)`""
        }
    }
}

# Left empty intentionally to override BeforeUpdate in keepass.install
function global:au_BeforeUpdate { }

function global:au_GetLatest {
    $version = (choco search f.lux.install --exact --by-id-only --limit-output | ConvertFrom-Csv -Delimiter '|' -Header 'name', 'version').version

    return @{
        Version = ConvertTo-VersionNumber -Version ([version]$version) -Part 3
    }
}

Update-Package -ChecksumFor none