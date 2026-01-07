. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://www.oo-software.com/en/download/current/ooshutup10'

function global:au_SearchReplace {
    @{
        ".\tools\VERIFICATION.txt" = @{
            "(^\s*x86 URL:\s*)(.*)"           = "`${1}$($Latest.URL32)"
            "(^\s*x86 Checksum:\s*)(.*)"      = "`${1}$($Latest.Checksum32)"
            "(^\s*x86 Checksum Type:\s*)(.*)" = "`${1}$($Latest.ChecksumType32)"
        }
    }
}

function global:au_BeforeUpdate {
    $toolsPath = Join-Path -Path $PSScriptRoot -ChildPath 'tools'
    New-Item -Path $toolsPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    Get-RemoteFiles -Purge
    Move-Item -Path (Join-Path -Path $toolsPath -ChildPath '*.exe') -Destination (Join-Path -Path $toolsPath -ChildPath 'OOSU10.exe')
    $Latest.ChecksumType32 = 'SHA256'
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $url = $download_page.links | Where-Object href -Match 'OOSU10.exe' | Select-Object -First 1 -expand href
    if (($download_page.Content -match 'Build (?<version>([0-9.]+)),') -ne $true) {
        throw "Can't find version number on the page - has the page layout changed?"
    }

    @{
        URL32   = $url
        Version = $matches.version
    }
}

Update-Package -ChecksumFor none
