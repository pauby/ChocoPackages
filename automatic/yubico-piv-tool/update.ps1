#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases    = 'https://developers.yubico.com/yubico-piv-tool/Releases/'    # must end with a trailing slash
$hashAlgorithm = 'SHA256'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            '(^\s*file\s*=\s*)(''.*'')'           = "`$1""`$toolsDir\$($Latest.File)"""
            '(^\s*file64\s*=\s*)(''.*'')'         = "`$1""`$toolsDir\$($Latest.File64)"""
            # "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            # "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_BeforeUpdate {

    $downloadClient = New-Object System.Net.WebClient

    try {
        $downloadedFilePath = Join-Path -Path (Resolve-Path 'tools') -ChildPath $Latest.File
        $downloadClient.DownloadFile($Latest.URL32, $downloadedFilePath)

        $downloadedFilePath = Join-Path -Path (Resolve-Path 'tools') -ChildPath $Latest.File64
        $downloadClient.DownloadFile($Latest.URL64, $downloadedFilePath)
    }
    catch {
        throw $_
    }
    finally {
        $downloadClient.Dispose()
    }
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = "yubico-piv-tool-(?<version>[\d\.]+)(?<letter>[a-z]{1})*-win64.msi$"

    $url64 = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href
    $url32 = $url64 -replace '-win64.msi', '-win32.msi'
    if ($matches.letter) {
        $version = "{0}.{1}" -f $matches.version, [convert]::ToInt16([char]$matches.letter)
    }
    else {
        $version = "{0}.0" -f $matches.version
    }

    return @{
        URL32        = "{0}{1}" -f $releases, $url32
        URL64        = "{0}{1}" -f $releases, $url64
        File         = $url32
        File64       = $url64
        Version      = $version
    }
}

Update-Package -ChecksumFor none