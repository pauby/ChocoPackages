#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://www.adobe.com/solutions/ebook/digital-editions/download.html'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
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
    # This needs to use curl.exe as it supports HTTP/2 and the Invoke-WebRequest cmdlet doesn't
    # This website needs HTTP/2
    $page = curl.exe $releases

    $regexVer = "Adobe Digital Editions (?<version>[\d\.]+) Installers"
    $regexUrl = "ADE_.*_installer.exe"

    # There must be a better way of doing this
    # This code is garbage.
    # When doing a -match against the $page it returns the actual line that matches, as an array, and 
    # not a boolean (and $matches with the results).
    # So we take the first element of the array, do another regex match and get the values we need
    if (($page -match $regexVer)[0] -match $regexVer) {
        $version = $matches['version']
    }
    
    ($page -match $regexUrl)[0] -match $regexUrl | Out-Null
    $url = "https://adedownload.adobe.com/pub/adobe/digitaleditions/$($matches[0])"

    return @{
        URL32        = $url
        Version      = $version

    }
}

update -ChecksumFor none
