#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://keepass.info/download.html'

function global:au_SearchReplace {
    @{
    }
}

function global:au_BeforeUpdate() {
    Invoke-WebRequest -Uri $Latest.Url32 -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox `
        -UseBasicParsing -OutFile "tools\KeePass-Setup.exe"
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $regex = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/(?<version>[\d\.]+)/KeePass-[\d\.]+-Setup.exe/download'
    $url = ($page.links | Where-Object href -Match $regex | Select-Object -First 1).href

    return @{
        URL32   = $url
        Version = ConvertTo-VersionNumber -Version ([version]$matches.version) -Part 3
    }
}

Update-Package -ChecksumFor None
