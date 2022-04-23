#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://files.dsnetwb.com/aTube_Catcher_FREE_9961.exe'
$hashAlgorithm = 'SHA256'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'          = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri $releases -OutFile $tempFile -UseBasicParsing
    $version = (Get-Item $tempfile).VersionInfo.FileVersion.Trim()

    return @{
        URL32   = $releases
        Checksum32 = (Get-FileHash -Path $tempfile -Algorithm $hashAlgorithm).Hash
        ChecksumType32 = $hashAlgorithm
        Version = $version
    }
}

Update-Package -ChecksumFor none