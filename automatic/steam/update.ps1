import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releases -OutFile $tempFile
    $version = (Get-Item $tempfile).VersionInfo.FileVersion

    return @{
        URL32           = $releases
        Version         = $version
        Checksum32      = ((Get-FileHash -Path $tempFile -Algorithm SHA256).Hash)
        ChecksumType32  = 'SHA256' 
    }
}

update -ChecksumFor 32