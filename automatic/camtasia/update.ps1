import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://support.techsmith.com/hc/en-us/articles/115006443267%C2%A0'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
    $Latest.ChecksumType64 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases
    $regexUrl = ": Camtasia \(Windows\) ([\d\.]+)"

    $page.content -match $regexUrl
    $version = $matches[1]

    $urlVer = $version.Replace('.', '')
    $url = "https://download.techsmith.com/camtasiastudio/enu/$urlVer/camtasia.msi"

    return @{
        URL64        = $url
        Version      = $version
    }
}

update -ChecksumFor none