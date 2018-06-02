#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://justgetflux.com/flux-setup.exe'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*url\s*=\s*)(''.*'')'          = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate() {
#    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
#    $Latest.ChecksumType32 = 'SHA256'
}

function global:au_AfterUpdate { 
    Set-DescriptionFromReadme -SkipFirst 2 
}

function global:au_GetLatest {
    $tempFile = New-TemporaryFile
    $tempPath = Split-Path -Path $tempFile -Parent
    Invoke-WebRequest -Uri $releases -OutFile $tempFile -UseBasicParsing
    & 7z.exe e -aoa $tempFile "flux.exe"
    $version = (Get-Item "flux.exe").VersionInfo.FileVersion -replace ", ", "." # version has commas between numbers !!!??!
    # the version number for f.lux appear to always have 4 segments
    # if the last 2 are 0 then skip them
    if ($version -match "(^\d+\.\d+)\.0\.0") {
        $version = $matches[1]
    }

    $fileHash = (Get-FileHash -Path $tempFile -Algorithm SHA256).Hash

    return @{
        URL32           = $releases
        Version         = $version
        Checksum32      = $fileHash
        ChecksumType32  = 'SHA256'
    }
}

update -ChecksumFor none