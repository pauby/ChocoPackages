import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://secure.logitech.com/en-gb/product/spotlight-presentation-remote/page/spotlight-features'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'              = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
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

    $regex = 'https://.*/logipresentation_(?<version>.*)\.exe'
    $page -match $regex
    
    return @{
        URL32        = $matches[0]
        Version      = $matches.version
    }
}

Update-Package