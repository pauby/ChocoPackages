#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://download.wavebox.app/appcast/appcast.xml?platform=win32&channel=beta'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url64bit\s*=\s*)('.*')"         = "`$1'$($Latest.Url64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {

    $releases = Invoke-RestMethod -Method get -Uri $releases | Select-Object -First 1
    if (-not $releases) {
        throw "No releases found in '$releases' - has something changed?!"
    }

    return @{
        Url64   = $releases.enclosure.url
        Version = $releases.enclosure.shortVersionString
        ReleaseNotes = $releases.releaseNotesLink
    }
}

Update-Package -ChecksumFor 64