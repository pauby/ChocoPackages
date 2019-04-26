#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://freecommander.com/en/downloads/'

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
    $Latest.ChecksumType32 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $regex  = 'FreeCommander XE (?<year>\d{4}) Build (?<minor>\d+)(?<patch>[a-z]?)'
    if ($page.content -match $regex) {
        $version = "$($matches.year).$($matches.minor)"

        if ($matches.patch) {
            # to have a patch of 'a' be a '.1' we need to reduce it by the ASCII
            # value of 'a', minus 1
            $lowerVal = [int]([char]'a') - 1
            $asciiVal = [int]([char]($matches.patch.ToLower())) - $lowerVal
            $version += ".$asciiVal"
        }
    }
    $url = "http://freecommander.com/downloads/FreeCommanderXE-32-public_setup.zip"

    return @{
        URL32        = $url
        Version      = $version
    }
}

update -ChecksumFor none
