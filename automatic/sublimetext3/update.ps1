#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://www.sublimetext.com/3'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'              = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
            '(^\s*url64\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"            
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
    $Latest.ChecksumType32 = 'SHA256'
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
    $Latest.ChecksumType64 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexVersion = '\<h3\>(?<version>[\d\.]+)\s*\(Build'
    $null = $page.rawcontent -match $regexVersion
    $version = $matches.version

    $regexUrl32 = 'https://download.sublimetext.com/Sublime Text Build \d+ Setup.exe'
    $regexUrl64 = 'https://download.sublimetext.com/Sublime Text Build \d+ x64 Setup.exe'
    $url32 = ($page.links | Where-Object href -match $regexUrl32 | Select-Object -First 1 -expand href).Replace(' ', '%20')
    $url64 = ($page.links | Where-Object href -match $regexUrl64 | Select-Object -First 1 -expand href).Replace(' ', '%20')

    return @{
        URL32   = $url32
        URL64   = $url64
        Version = $version
    }
}

update -ChecksumFor none