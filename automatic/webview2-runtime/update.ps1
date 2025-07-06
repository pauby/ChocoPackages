#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(?i)(^\s*\$softwareVersion\s*=\s*)(''.*'')'      = "`$1'$($Latest.Version)'"
            "(?i)(^\s*url\s*=\s*)('.*')"                    = "`$1'$($Latest.Url32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"               = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*url64\s*=\s*)('.*')"                  = "`$1'$($Latest.Url64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"             = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"           = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $latestVersion = Get-EvergreenApp -Name 'MicrosoftEdgeWebView2Runtime'

    $version = ($latestVersion | Where-Object architecture -eq 'x86').Version
    $url32 = ($latestVersion | Where-Object architecture -eq 'x86').URI
    $url64 = ($latestVersion | Where-Object architecture -eq 'x64').URI

    return @{
        Url32   = $url32
        Url64   = $url64
        Version = $version
    }
}

Update-Package -ChecksumFor all