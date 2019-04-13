#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://www.virtualbox.org/wiki/Downloads'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $regex = 'VirtualBox</a>\s(?<version>.*)\splatform packages'
    $page -match $regex

    return @{
        URL32   = ("https://download.virtualbox.org/virtualbox/{0}/VBoxGuestAdditions_{0}.iso" -f $matches.version)
        Version = $matches.version
    }
}

Update-Package