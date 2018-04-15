import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releasesx86 = 'https://www.onenote.com/download/win32/x86/en-US'
$releasesx64 = 'https://www.onenote.com/download/win32/x64/en-US'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'             = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
            '(^\s*url64\s*=\s*)(''.*'')'           = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releasesx86 -OutFile $tempFile -UseBasicParsing
    $version = (Get-Item $tempfile).VersionInfo.FileVersion

    return @{
        URL32   = $releasesx86
        URL64   = $releasesx64
        Version = $version
    }
}

update -ChecksumFor all