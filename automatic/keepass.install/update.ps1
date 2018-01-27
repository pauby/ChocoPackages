import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://keepass.info/download.html'

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

    $regex = 'KeePass (?<version>2\.\d+) \(Installer EXE for Windows\)'
    $url = ($page.links | Where-Object innerText -match $regex | Select-Object -First 1).href
    $url = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.38/KeePass-2.38-Setup.exe/download'

    return @{
        URL32        = $url
        Version      = $matches.version
    }
}

Update-Package -ChecksumFor none
