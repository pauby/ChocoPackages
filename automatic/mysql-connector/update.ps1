#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://dev.mysql.com/downloads/connector/net/'

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
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = "(mysql-connector-net-(.*).msi)"

    $page.content -match $regexUrl | Out-Null
    $version = $matches[2]

    return @{
        URL32        = "https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-$version.msi"
        Version      = $version
    }
}

update -ChecksumFor none