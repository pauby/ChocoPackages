import-module au

#Virtual package uses dependency updater to get the version
. $PSScriptRoot\..\keepass.install\update.ps1

$releases = 'https://discordapp.com/api/download?platform=win'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"$($Latest.Version)`""
        }
    }
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

# Left empty intentionally to override BeforeUpdate in discord.install
function global:au_BeforeUpdate { }

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releases -OutFile $tempFile -UseBasicParsing
    $version = (Get-Item $tempfile).VersionInfo.FileVersion

    return @{
        Version = $version
    }
}

update -ChecksumFor none