#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://keepass.info/download.html'

function global:au_SearchReplace {
    @{
    }
}

function global:au_BeforeUpdate() {
    Invoke-WebRequest -Uri $Latest.Url32 -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox `
        -UseBasicParsing -OutFile 'tools\KeePass-Setup.zip'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {

    $app = (Get-EvergreenApp -Name KeePass) | Where-Object { $_.architecture -eq 'x86' -and $_.type -eq 'exe' }

    $url = ("https://unlimited.dl.sourceforge.net/project/keepass/KeePass%202.x/{0}/KeePass-{0}.zip" -f $app.version )

    return @{
        URL32   = $url
        Version = ConvertTo-VersionNumber -Version ([version]$app.version) -Part 3
    }
}

Update-Package -ChecksumFor None