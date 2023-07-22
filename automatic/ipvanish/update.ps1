#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://www.ipvanish.com/software/setup-prod-v2/ipvanish-setup.exe'
$checksumType = 'SHA256'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(?i)(^\s*url\s*=\s*)(''.*'')'        = "`$1'$($Latest.URL32)'"
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
    $tempFile = New-TemporaryFile
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $releases -OutFile $tempFile -UseBasicParsing
    $version = (Get-Item $tempfile).VersionInfo.ProductVersion

    return @{
        URL32   = $releases
        Version = $version
        Checksum32 = (Get-FileHash -Path $tempFile -Algorithm $checksumType).Hash
        ChecksumType32 = $checksumType
    }
}

update -ChecksumFor none