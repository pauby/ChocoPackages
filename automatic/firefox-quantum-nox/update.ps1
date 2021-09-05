#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://github.com/Izheil/Quantum-Nox-Firefox-Dark-Full-Theme/releases' # no trailing slash!

function global:au_SearchReplace {
    @{}
}

function global:au_BeforeUpdate {
    Invoke-WebRequest -Uri $Latest.Url32 -UseBasicParsing -OutFile 'tools\quantum-nox.exe'
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = '/download/[F]{1,2}\d+/Multirow-Patcher-Quantum-Nox-Installer-Windows-(?<version>[\d\.]+).exe'
    $page.links | Where-Object href -Match $regexUrl | Select-Object -First 1 -expand href

    return @{
        URL32   = ("{0}{1}" -f $releases, $matches[0])
        Version = $matches.version
    }
}

Update-Package -ChecksumFor 32