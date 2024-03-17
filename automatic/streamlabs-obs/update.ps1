. $PSScriptRoot\..\..\scripts\all.ps1

$releases = "https://streamlabs.com/streamlabs-desktop/download?sdb=1"


function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]url(64)?\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*[$]checksum(64)?\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*[$]checksumType\s*=\s*)('.*')"  = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_AfterUpdate($Package) {
}

function global:au_GetLatest {
    $page = Get-RedirectedUrl $releases

    $url64 = $page -replace ("\?.+", "")
    $version = $url64 -split 'Setup\+|.exe' | Select-Object -Last 1 -Skip 1

    return @{
        Version = $version
        URL64   = $url64
    }
}

update -ChecksumFor 64
