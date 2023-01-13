#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://github.com/ligos/readablepassphrasegenerator/releases/latest'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
        }
        ".\tools\chocolateyUninstall.ps1" = @{
            '(^\s*\$pluginFilename\s*=\s*)(''ReadablePassphrase%20.*'')' = "`$1'ReadablePassphrase%20$($Latest.Version).plgx'"
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
    $regexUrl = 'ReadablePassphrase\.(?<version>[\d\.]+)\.plgx$'

    $url = $page.links | Where-Object href -match $regexUrl | Select-Object -first 1 -expand href
    $version = $matches.version

    return @{
        URL32        = "https://github.com$url"
        Version      = $version
    }
}

update -ChecksumFor none
