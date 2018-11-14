#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://aka.ms/WACDownload'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'            = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate {
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $exeFilename = 'smeDesktop.exe'
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releases -OutFile $tempFile -UseBasicParsing
    & 7z.exe e -aoa $tempFile $exeFilename

    $version = (Get-Item $exeFilename).VersionInfo.FileVersion

    return @{
        URL32          = $releases
        Version        = $version
        Checksum32     = (Get-FileHash -Path $tempFile -Algorithm SHA256).Hash
        ChecksumType32 = 'SHA256'
    }
}

update -ChecksumFor none