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
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $regex = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/(?<version>[\d\.]+)/KeePass-[\d\.]+-Setup.exe/download'
    $url = ($page.links | Where-Object href -Match $regex | Select-Object -First 1).href

    return @{
        Version = ConvertTo-VersionNumber -Version ([version]$matches.version) -Part 3
    }
}

Update-Package -ChecksumFor None
