. $PSScriptRoot\..\..\scripts\all.ps1

$releases = "https://tuxproject.de/projects/vim/"

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"$($Latest.Version)`""
        }
    }
}

# Left empty intentionally
function global:au_BeforeUpdate { }

function global:au_GetLatest {

    $matches = $null
    ((Invoke-WebRequest -Uri $releases -UseBasicParsing).RawContent.Split("`n") | Select-String '<title>') -match "(\d+)\.(\d+)\.\d+"
    $version = $matches[0]
    $versionPath = "vim" + $matches[1] + $matches[2]

    return @{
        Version      = $version
    }
}

Update-Package -ChecksumFor none
