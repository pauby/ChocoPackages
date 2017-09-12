import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'http://download100.lavasoft.com/adaware/updates/Adaware_Installer_free.exe'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$url\s*=\s*)(''.*'')'          = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
    $Latest.ChecksumType32 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releases -OutFile $tempFile
    $version = (Get-Item $tempfile).VersionInfo.FileVersion -replace ",", "." # version has commas between numbers !!!??!

    return @{
        URL32   = $releases
        Version = $version
    }
}

update -ChecksumFor none