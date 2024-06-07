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

    $app = (Get-EvergreenApp -Name KeePass) | Where-Object { $_.architecture -eq 'x86' -and $_.type -eq 'exe' }

    return @{
        URL32   = $app.URI
        Version = ConvertTo-VersionNumber -Version ([version]$app.version) -Part 3
    }
}

Update-Package -ChecksumFor None
