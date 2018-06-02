#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
            '(?i)(^\s*\$checksum64\s*=\s*)(''.*'')' = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    Invoke-WebRequest -Uri 'https://getonetastic.com/downloadFile&fv=0&file=OnetasticInstaller.x86.exe&agree=1' `
        -OutFile $tempFile -UseBasicParsing
    $version = (Get-Item $tempfile).VersionInfo.FileVersion

    return @{
        URL32          = 'https://getonetastic.com/downloadFile&fv=0&file=OnetasticInstaller.x86.exe&agree=1'
        Checksum32     = (Get-FileHash -Path $tempFile -Algorithm SHA256).Hash
        ChecksumType32 = 'SHA256'
        URL64          = 'https://getonetastic.com/downloadFile&fv=0&file=OnetasticInstaller.x64.exe&agree=1'
        Version        = $version
    }
}

update -ChecksumFor none