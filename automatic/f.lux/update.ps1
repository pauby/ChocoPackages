import-module au

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
    (clist f.lux.install -e --by-id-only | select -Skip 1 | select -SkipLast 1) -match '^.+?\s+(?<version>.+?)\s+'
    
    return @{
        Version = $matches.version
    }
}

update -ChecksumFor none