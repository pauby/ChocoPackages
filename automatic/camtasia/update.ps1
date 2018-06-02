#import-module au

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
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = ": Camtasia \(Windows\) ([\d\.]+)"

    $page.content -match $regexUrl
    $version = $matches[1]

    $urlVer = $version.Replace('.', '')
    $url = "https://download.techsmith.com/camtasiastudio/enu/$urlVer/camtasia.msi"

    # As we messed up the versions a little we need to make sure the minor vwersion number is 2 digits long and has trailing zeroes.
    # When Camtasia reaches major version 10 we can correct this.
    # Chocolatey (or Nuget specs to be more precise) ignore any leading zeroes. and for some reason version 9.0.5 (and earlier) of Camtastia was being 
    # reported as 9.05 - that needs looked into too but in the meantime this is a fix.

    # extract the minor version
    $version -match "\d\.(\d)" | Out-Null
    $minor = if ($matches[1].length -lt 2 -and $matches[1][0] -ne "0") { 
        "$($matches[1])0" 
    } else { 
        $matches[1]
    }
    $version = $version -replace "(\d)\.\d\.(\d)", "`$1.$minor.`$2"
    
    return @{
        URL64        = $url
        Version      = $version
    }
}

update -ChecksumFor none