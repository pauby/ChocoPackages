import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'http://fineprint.com/pdfp/release-notes/'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*\$url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
    $Latest.checksumType32 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $regexUrl = 'pdf(.*)pro.exe'
    $link = $page.links | Where-Object href -match $regexUrl | Select -First 1
    $url = $link.href
    if ($link.outerHTML -match "DOWNLOAD v([\d\.]+)") { $version = $matches[1] }
        
    return @{
        URL32        = $url
        Version      = $version
    }
}

update -ChecksumFor none