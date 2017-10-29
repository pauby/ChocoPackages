import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'http://www.e7z.org/free-download.htm'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')"              = "`$1'$($Latest.URL32)'"
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
    $page = Invoke-WebRequest -Uri $releases

    $regexVer = "Version([\d\.]+)"
    if ($page.ParsedHtml.body.outerText -match $regexVer) { $version = $matches[1] }
    return @{
        URL32   = "http://www.e7z.org/easy7zip_x86_x64.exe"
        Version = $version
    }
}

update -ChecksumFor none
